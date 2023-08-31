# frozen_string_literal: true

class TransactionContract < Dry::Validation::Contract
  params do
    required(:type).filled(:string)
  end
end
