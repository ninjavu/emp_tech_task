# frozen_string_literal: true

class Transaction::Charge < Transaction
  validates :amount, presence: true
  validates_numericality_of :amount, greater_than: 0

  has_one :refund_transaction,
          class_name: 'Transaction::Refund',
          foreign_key: 'transaction_reference'
end
