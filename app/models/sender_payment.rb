# == Schema Information
#
# Table name: payments
#
#  id              :integer          not null, primary key
#  paypal_id       :string(255)
#  payer_id        :string(255)
#  type            :string(255)
#  intent          :integer
#  state           :integer
#  transaction_id  :integer
#  data            :text(65535)
#  error           :text(65535)
#  recipient_email :string(255)
#  recipient_phone :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  capture_id      :integer
#
# Indexes
#
#  index_payments_on_created_at      (created_at)
#  index_payments_on_payer_id        (payer_id)
#  index_payments_on_paypal_id       (paypal_id)
#  index_payments_on_transaction_id  (transaction_id)
#

require 'paypal-sdk-rest'

class SenderPayment < Payment
  delegate :sender, to: :listing_transaction
  delegate :payer, to: :listing_transaction

  # NOTE: disabled as might not be needed with validation afterward
  # phony_normalize :recipient_phone#, default_country_code: 'US'

  validates :recipient_phone, phony_plausible: true
  validates :recipient_email, email: true

  validate :paypal_payment_created, on: :create
  validate :paypal_payment_executed, on: :update

  attr_accessor :return_url, :cancel_url


  def owner
    sender
  end

  def recipient
    community = listing_transaction.community
    Person.joins(:emails).where(emails: {address: recipient_email, community_id: community.id}, community_id: community.id).first
  end

  def confirmation_number
    paypal_id && paypal_id.sub('PAY-', '')
  end

  #TODO transactionability support
  #TODO send email to confirm capture for sender
  def capture_payment!
    return if captured?
    capture = paypal_authorization.capture({:amount => paypal_amount, :is_final_capture => true})
    if capture.success?
      self.update_attribute(:capture_id, capture.id)
    else
      raise "Capture for #{paypal_id} failed!"
    end
  rescue => err
    Rails.logger.error err.message
    Rails.logger.error err.backtrace.join
    raise err
  end

  def captured?
    self.capture_id.present?
  end

  def paypal_payment
    @paypal_payment = PayPal::SDK::REST::Payment.find(self.paypal_id)
  end

  def paypal_authorization
    paypal_payment.transactions[0].related_resources[0].authorization
  end

  def paypal_amount
    data['transactions'][0]['related_resources'][0]['authorization']['amount']
  end

  private

  #TODO offload to background with delayed job

  def paypal_payment_created
    self.data = {
      :intent => intent,
      :redirect_urls => { #TODO fix by updating variable redirect_urls and breaking it down
        :return_url => return_url,
        :cancel_url => cancel_url
      },
      :payer => {
        :payment_method => "paypal",
      },
      :transactions => [{
        :item_list => {
          :items => [{
            :name => listing_transaction.listing.title,
            :sku => listing_transaction.listing.listing_shape.name,
            :price => listing_transaction.listing.price.to_f,
            :currency => listing_transaction.listing.price.currency.iso_code,
            :quantity => 1 }]},
        :amount => {
          :total => listing_transaction.listing.price.to_f.to_s,
          :currency => listing_transaction.listing.price.currency.iso_code },
        :description => listing_transaction.listing.title }]
    }
    @paypal_payment = PayPal::SDK::REST::Payment.new(self.data)

    if @paypal_payment.create
      self.paypal_id = @paypal_payment.id     # Payment Id
      self.state = @paypal_payment.state
      self.data = @paypal_payment.to_hash
    else
      self.paypal_id = nil
      self.error = @paypal_payment.error  # Error Hash
      self.errors[:paypal_id] << "#{self.error['message']}: [#{self.error['name']}] #{self.error['details'][0]['field']} <- #{self.error['details'][0]['issue']}"
    end
  end

  #TODO handle error conditions by using transactions and paypal-payment re-lookup
  def paypal_payment_executed
    return unless payer_id.present? && payer_id_changed?
    self.error = nil
    @paypal_payment = PayPal::SDK::REST::Payment.find(paypal_id)
    if @paypal_payment.execute( :payer_id => payer_id )
      self.state = @paypal_payment.state
      self.data = @paypal_payment.to_hash
      recipient = Person.autocreate_for(recipient_email, listing_transaction.community)
      PersonMailer.delay.confirm_delivery(recipient, self)
      PersonMailer.delay.confirm_delivery(listing_transaction.traveller, self)
      listing.update_attribute(:open, false)
    else
      self.error = @paypal_payment.error  # Error Hash
      self.errors[:paypal_id] << "#{self.error['message']}: [#{self.error['name']}] #{self.error['details'][0]['field']} <- #{self.error['details'][0]['issue']}"
    end
  end


end
