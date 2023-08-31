# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant::IndexInteractor, type: :interactor do
  subject(:interactor) { described_class.new(token:, params:) }

  let(:token) { '123123123' }
  let(:params) { ActionController::Parameters.new(data) }
  let(:data) { {} }

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

  describe 'find_merchants' do
    before do
      allow(TokenCheckInteractor).to receive_message_chain(:new, :call, :user).and_return(user)
      create(:merchant, :active)
      create(:merchant, :inactive)
      create(:merchant, :inactive)
    end

    context 'with params' do
      let(:data) { { status: 'inactive' } }

      it 'it returns only active merchants' do
        ctx = interactor.call
        expect(ctx.merchants.count).to be(2)
      end
    end

    context 'without params' do
      let(:data) { {} }

      it 'it returns all merchants' do
        ctx = interactor.call
        expect(ctx.merchants.count).to be(3)
      end
    end
  end
end
