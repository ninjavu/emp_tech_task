# frozen_string_literal: true

RSpec.describe Transaction::Reversal, type: :model do
  describe 'validations' do
    it { should validate_absence_of(:amount) }
  end
end
