# frozen_string_literal: true

class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.string :name, null: false
      t.string :description
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
