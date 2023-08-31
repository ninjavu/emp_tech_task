# frozen_string_literal: true

class Merchant < ApplicationRecord
  include ::Userable
  include ::Activable

  validates :name, :description, presence: true

  has_many :transactions

  def total_transaction_sum
    transactions
      .where(type: 'Transaction::Charge')
      .approved
      .sum(:amount)
  end
end
