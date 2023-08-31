# frozen_string_literal: true

class Transaction::Refund < Transaction
  validates :amount, presence: true
  validates_numericality_of :amount, greater_than: 0
end
