# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should belong_to(:userable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('user.com').for(:email) }
  end
end
