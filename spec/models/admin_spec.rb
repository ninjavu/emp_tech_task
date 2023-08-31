# frozen_string_literal: true

RSpec.describe Admin, type: :model do
  describe 'associations' do
    it { should have_one(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in?(Merchant::STATUSES) }
  end
end
