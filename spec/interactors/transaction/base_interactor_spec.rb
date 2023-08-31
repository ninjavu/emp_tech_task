# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::BaseInteractor, type: :interactor do
  subject(:interactor) { described_class.new(token:, params:) }

  let(:token) { '123123123' }
  let(:params) { ActionController::Parameters.new(data) }
  let(:data) { { type: 'authorize' } }

  let(:merchant) { create(:merchant) }

  describe 'params checking' do
    context 'when type is valid' do
      it 'it does not throw error' do
        ctx = interactor.call
        expect(ctx.errors[:server]).not_to be('Please, write :type parameter')
      end
    end

    context 'when type is absent' do
      let(:data) { {} }

      it 'it returns error' do
        ctx = interactor.call
        expect(ctx.errors[:server]).to be('Please, write :type parameter')
      end
    end

    context 'when type is wrong' do
      let(:data) { { type: 'wrong_type' } }

      it 'it returns error' do
        ctx = interactor.call
        expect(ctx.errors[:server]).to be('unknown transaction type')
      end
    end
  end

  describe 'authenticate' do
    context 'when success auth' do
      before do
        allow(TokenCheckInteractor).to receive_message_chain(:new, :call, :user).and_return(merchant)
        allow(interactor).to receive(:process_transaction_by_type)
      end

      it 'finds user' do
        ctx = interactor.call
        expect(ctx.merchant).to be(merchant)
      end
    end

    context 'when Auth header is empty' do
      let(:token) { nil }

      it 'it returns Auth error' do
        ctx = interactor.call
        expect(ctx.errors[:server]).to be('Authorization header is empty')
      end
    end

    context 'when Auth token is wrong' do
      let(:token) { 'test' }

      it 'it returns Not Found error' do
        ctx = interactor.call
        expect(ctx.errors[:server]).to be('Merchant Not Found')
      end
    end
  end

  describe 'merchant state' do
    before do
      allow(TokenCheckInteractor).to receive_message_chain(:new, :call, :user).and_return(merchant)
      allow(interactor).to receive(:process_transaction_by_type)
    end

    context 'when merchant active' do
      let(:merchant) { create(:merchant, :active) }

      it 'it does not return error' do
        ctx = interactor.call
        expect(ctx.errors).not_to be(nil)
      end
    end

    context 'when merchant is inactive' do
      let(:merchant) { create(:merchant, :inactive) }

      it 'it returns error' do
        ctx = interactor.call
        expect(ctx.errors[:server]).to be('Merchant is inactive')
      end
    end
  end
end
