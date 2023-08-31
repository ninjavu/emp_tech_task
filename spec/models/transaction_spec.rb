# frozen_string_literal: true

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { should belong_to(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:customer_email) }
    it { should allow_value('user@example.com').for(:customer_email) }
    it { should validate_inclusion_of(:status).in?(Transaction::STATUSES) }
  end

  describe '.build_transaction_type_interactor_name' do
    it 'builds class with right type' do
      expect(
        subject.class.build_transaction_type_interactor_name(transaction_type: 'refund')
      ).to eq(Transaction::RefundInteractor)
    end

    it 'raises error if incorrect type is passed' do
      expect(
        subject.class.build_transaction_type_interactor_name(transaction_type: 'wrong_type')
      ).to be_nil
    end
  end

  describe '#able_to_reference?' do
    let(:approved_transaction) { build(:transaction, :approved) }
    let(:error_transaction) { build(:transaction, :error) }

    it 'references transaction with status :approved' do
      expect(approved_transaction.able_to_reference?).to be_truthy
    end

    it 'does not reference transaction with status :error' do
      expect(error_transaction.able_to_reference?).to be_falsey
    end
  end

  describe '.expired' do
    let!(:expired_transaction) { create(:transaction, :approved, created_at: 2.hours.ago) }
    let!(:transaction) { create(:transaction, :approved) }

    it 'returns transaction' do
      expect(subject.class.expired).to include(expired_transaction)
    end

    it 'does not return old transaction' do
      expect(subject.class.expired).not_to include(transaction)
    end
  end

  describe 'aasm' do
    let(:transaction) { build(:transaction) }

    it 'has inital state approved' do
      expect(transaction).to have_state(:approved)
    end

    it { expect(transaction).to transition_from(:approved).to(:refunded).on_event(:to_refunded) }
    it { expect(transaction).to transition_from(:approved).to(:reversed).on_event(:to_reversed) }

    it { expect(transaction).to transition_from(:approved).to(:error).on_event(:to_error) }
    it { expect(transaction).to transition_from(:refunded).to(:error).on_event(:to_error) }
    it { expect(transaction).to transition_from(:reversed).to(:error).on_event(:to_error) }

    it { expect(transaction).not_to transition_from(:approved).to(:reversed).on_event(:to_refunded) }
    it { expect(transaction).not_to transition_from(:approved).to(:refund).on_event(:to_error) }
    it { expect(transaction).not_to transition_from(:approved).to(:error).on_event(:to_reversed) }
  end
end
