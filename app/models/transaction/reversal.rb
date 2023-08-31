# frozen_string_literal: true

class Transaction::Reversal < Transaction
  validates :amount, absence: true
end
