class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :paypal_id
      t.string :payer_id
      t.string :type
      t.integer :intent
      t.integer :state
      t.integer :transaction_id
      t.text :data
      t.text :error
      t.string :recipient_email
      t.string :recipient_phone

      t.timestamps null: false
    end

    add_index :payments, :created_at, using: 'btree'
    add_index :payments, :paypal_id, using: 'btree'
    add_index :payments, :payer_id, using: 'btree'
    add_index :payments, :transaction_id, using: 'btree'
  end
end
