# frozen_string_literal: true

RSpec.describe Transaction::Refund, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
  end
end
