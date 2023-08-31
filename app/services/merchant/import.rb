# frozen_string_literal: true

require 'csv'

class Merchant::Import
  def call(file_name: "#{Rails.root}/lib/merchants.csv")
    CSV.foreach(file_name, headers: true) do |merchant|
      user = User.new(merchant.to_h.slice('email'))
      merchant = Merchant.new(merchant.to_h.except('email'))

      merchant.user = user
      merchant.save!
    rescue StandardError
      next
    end
  end
end
