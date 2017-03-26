# == Schema Information
#
# Table name: payments
#
#  id                  :integer          not null, primary key
#  paypal_id           :string(255)
#  payer_id            :string(255)
#  type                :string(255)
#  intent              :integer
#  state               :integer
#  transaction_id      :integer
#  data                :text(65535)
#  error               :text(65535)
#  recipient_email     :string(255)
#  recipient_phone     :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  capture_id          :integer
#  payout_batch        :text(65535)
#  confirmation_number :string(255)
#
# Indexes
#
#  index_payments_on_confirmation_number  (confirmation_number)
#  index_payments_on_created_at           (created_at)
#  index_payments_on_payer_id             (payer_id)
#  index_payments_on_paypal_id            (paypal_id)
#  index_payments_on_transaction_id       (transaction_id)
#

class Payment < ActiveRecord::Base
  enum intent: {
    sale: 0,
    authorize: 1
  }
  enum state: {
    created: 0,
    approved: 1,
    failed: 2
  }

  serialize :data, JSON
  serialize :error, JSON
  serialize :payout_batch, JSON

  belongs_to :listing_transaction, class_name: 'Transaction', foreign_key: 'transaction_id'
  delegate :listing, to: :listing_transaction
end
