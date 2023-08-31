# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::AuthorizeInteractor, type: :interactor do
  subject(:interactor) { described_class.new(params:) }

  let(:params) do
    {
      amount: 100,
      customer_email: 'test@test.com',
      customer_phone: '1111111',
      merchant_id: merchant.id
    }
  end

  let(:merchant) { create(:merchant) }

  describe 'transaction creation' do
    context 'when valid params' do
      it 'it creates authorize transaction' do
        interactor.call
        expect(Transaction::Authorize.count).to be(1)
      end

      it 'has no errors' do
        interactor.call
        ctx = interactor.call
        expect(ctx.errors).to be_empty
      end
    end

    context 'when invalid params' do
      let(:params) { { amount: '2' } }

      it 'it does not create authorize transaction' do
        interactor.call
        expect(Transaction::Authorize.count).to be(0)
      end

      it 'it returns error' do
        ctx = interactor.call
        expect(ctx.errors).to be_present
      end
    end
  end
end
