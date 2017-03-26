class AddConfirmationNumberToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :confirmation_number, :string
    add_index :payments, :confirmation_number
  end
end
