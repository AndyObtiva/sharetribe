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

class TravellerPayment < Payment
  delegate :traveller, to: :transaction
  delegate :payment_receiver, to: :transaction
  def owner
    traveller
  end
end
