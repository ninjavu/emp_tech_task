# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::RefundInteractor, type: :interactor do
  subject(:interactor) { described_class.new(params:) }

  let(:params) do
    {
      amount: 100,
      customer_email: 'test@test.com',
      customer_phone: '1111111',
      merchant_id: merchant.id,
      transaction_reference: ref_transaction.id
    }
  end

  let(:merchant) { create(:merchant) }
  let(:ref_transaction) { create(:transaction, :type_charge, merchant:, amount: 100) }

  describe 'ref transaction' do
    context 'when valid params' do
      it 'it finds ref transaction' do
        ctx = interactor.call
        expect(ctx.ref_transaction.id).to eq(ref_transaction.id)
      end
    end

    context 'when invalid params' do
      let(:params) do
        {
          transaction_reference: 'nil'
        }
      end

      it 'it returns error' do
        ctx = interactor.call
        expect(ctx.errors[:server]).to eq("Couldn't find Transaction::Charge with 'id'=nil")
      end
    end
  end

  describe 'amount verification' do
    context 'when valid amount' do
      it 'it does not return error' do
        ctx = interactor.call
        expect(ctx.errors).to be_empty
      end
    end

    context 'when invalid amount' do
      let(:ref_transaction) { create(:transaction, :type_authorized, amount: 200) }

      it 'it returns error' do
        ctx = interactor.call
        expect(ctx.errors[:server]).to be_present
      end
    end
  end

  describe 'other refund transactions existence' do
    context 'when exists' do
      let!(:other_transaction) do
        create(:transaction,
               :type_refund,
               merchant:,
               amount: 100,
               transaction_reference: ref_transaction.id)
      end

      it 'it returns error' do
        ctx = interactor.call
        expect(ctx.errors[:server]).to eq('refund transaction for this authorize transaction already exists')
      end
    end

    context 'when does not exist' do
      it 'it does not return error' do
        ctx = interactor.call
        expect(ctx.errors).to be_empty
      end
    end
  end

  describe 'status handling' do
    context 'when allowed status' do
      let(:ref_transaction) { create(:transaction, :type_charge, :approved, merchant:, amount: 100) }

      it 'it sets approved status' do
        ctx = interactor.call
        expect(ctx.transaction.status.to_sym).to eq(:approved)
      end
    end

    context 'when not allowed status' do
      let(:ref_transaction) { create(:transaction, :type_charge, :reversed, merchant:, amount: 100) }

      it 'it sets error status' do
        ctx = interactor.call
        expect(ctx.transaction.status.to_sym).to eq(:error)
      end
    end
  end

  describe 'transaction creation' do
    context 'when valid params' do
      it 'it creates Refund transaction' do
        interactor.call
        expect(Transaction::Refund.count).to be(1)
      end

      it 'has no errors' do
        ctx = interactor.call
        expect(ctx.errors).to be_empty
      end
    end

    context 'when invalid params' do
      let(:params) { { amount: '2' } }

      it 'it returns errors' do
        ctx = interactor.call
        expect(ctx.errors).to be_present
      end
    end
  end

  it 'it changes ref status' do
    ctx = interactor.call
    expect(ctx.ref_transaction.status.to_sym).to be(:refunded)
  end
end
