class AddPayoutBatchToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :payout_batch, :text
  end
end
