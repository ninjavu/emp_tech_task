# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions, id: :uuid do |t|
      t.integer :amount, limit: 4
      t.integer :status, null: false
      t.string :customer_email
      t.string :customer_phone
      t.string :type, null: false
      t.integer :merchant_id, null: false
      t.uuid :transaction_reference

      t.timestamps
    end

    add_index :transactions, :merchant_id
    add_index :transactions, :transaction_reference
  end
end
