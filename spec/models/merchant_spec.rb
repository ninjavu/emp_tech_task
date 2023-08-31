# frozen_string_literal: true

RSpec.describe Merchant, type: :model do
  describe 'associations' do
    it { should have_many(:transactions) }
    it { should have_one(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in?(Merchant::STATUSES) }
  end

  describe '#total_transaction_sum' do
    let!(:merchant) { create(:merchant, :with_approved_charged_transactions) }

    it "should calculate sum of approved charge transactions right" do
      expect(Merchant.find(merchant.id).total_transaction_sum).to eq(100)
    end
  end
end
