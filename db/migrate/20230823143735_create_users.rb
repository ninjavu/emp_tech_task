# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string  :email
      t.bigint  :userable_id
      t.string  :userable_type
      t.timestamps
    end

    add_index :users, [:userable_type, :userable_id]
    add_index :users, :email, unique: true
  end
end
