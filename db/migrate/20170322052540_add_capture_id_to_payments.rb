class AddCaptureIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :capture_id, :integer
  end
end
