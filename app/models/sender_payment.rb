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
  delegate :sender, to: :transaction
  delegate :payer, to: :transaction

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

  private

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

  def paypal_payment_executed
    return unless payer_id.present? && payer_id_changed?
    self.error = nil
    @paypal_payment = PayPal::SDK::REST::Payment.find(paypal_id)
    if @paypal_payment.execute( :payer_id => payer_id )
      self.state = @paypal_payment.state
      self.data = @paypal_payment.to_hash
    else
      self.error = @paypal_payment.error  # Error Hash
      self.errors[:paypal_id] << "#{self.error['message']}: [#{self.error['name']}] #{self.error['details'][0]['field']} <- #{self.error['details'][0]['issue']}"
    end
  end


end
