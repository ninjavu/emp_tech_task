# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant::UpdateInteractor, type: :interactor do
  subject(:interactor) { described_class.new(token:, params:) }

  let(:token) { '123123123' }
  let(:params) { ActionController::Parameters.new(data) }
  let(:data) { { id: merchant.id } }

  let(:merchant) { create(:merchant) }

  let(:user) { create(:admin) }

  describe 'authenticate' do
    context 'when success auth' do
      before do
        allow(TokenCheckInteractor).to receive_message_chain(:new, :call, :user).and_return(user)
      end

      it 'it finds user' do
        ctx = interactor.call
        expect(ctx.user).to be(user)
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
        expect(ctx.errors[:server]).to be('User Not Found')
      end
    end
  end

  describe 'merchant flow' do
    before do
      allow(TokenCheckInteractor).to receive_message_chain(:new, :call, :user).and_return(user)
    end

    context 'when merchant exists' do
      let(:data) { { id: merchant.id } }

      it 'it finds merchant' do
        ctx = interactor.call
        expect(ctx.merchant).to eq(merchant)
      end
    end

    context 'when merchant not found' do
      let(:data) { { id: 0 } }

      it 'it returns error' do
        ctx = interactor.call
        expect(ctx.errors[:server]).to eq("Couldn't find Merchant with 'id'=0")
      end
    end
  end

  describe 'merchant update flow' do
    before do
      allow(TokenCheckInteractor).to receive_message_chain(:new, :call, :user).and_return(user)
    end

    let(:merchant) { create(:merchant, :active) }
    let(:data) { { id: merchant.id, status: } }
    let(:status) { :active }

    context 'success update' do
      let(:status) { :inactive }

      it 'it updates merchant' do
        ctx = interactor.call
        expect(ctx.merchant.status.to_sym).to eq(status)
      end
    end

    context 'failed update' do
      let(:status) { :wrong_status }

      it 'it returns error' do
        ctx = interactor.call
        expect(ctx.errors[:server]).to eq("'wrong_status' is not a valid status")
      end
    end
  end
end
