# frozen_string_literal: true

class Transaction::Authorize < Transaction
  validates :amount, presence: true
  validates_numericality_of :amount, greater_than: 0

  has_one :charge_transaction,
          class_name: 'Transaction::Charge',
          foreign_key: 'transaction_reference'
          
  has_one :reversal_transaction,
          class_name: 'Transaction::Reversal',
          foreign_key: 'transaction_reference'
end
