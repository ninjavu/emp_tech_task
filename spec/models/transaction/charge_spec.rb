# frozen_string_literal: true

RSpec.describe Transaction::Charge, type: :model do
  describe 'associations' do
    it { should have_one(:refund_transaction) }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
  end
end
