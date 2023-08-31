# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticateInteractor, type: :interactor do
  subject(:interactor) { described_class.new(resource:, params:) }

  let(:params) { { email: } }
  let(:email) { 'test@test.com' }
  let(:token) { '123123123' }
  let(:resource) { User }

  describe 'authenticate process' do
    before do
      allow(Utils::Token::Initializer).to receive_message_chain(:new, :call).and_return(token)
    end

    context 'when admin exisst' do
      let(:admin) { create(:admin) }
      let(:email) { admin.user.email }

      it 'it finds user' do
        ctx = interactor.call
        expect(ctx.resource).to eq(admin.user)
      end

      it 'it defines role' do
        ctx = interactor.call
        expect(ctx.role).to eq(admin.user.userable_type)
      end

      it 'it initialize token' do
        ctx = interactor.call
        expect(ctx.token).to eq(token)
      end
    end

    context 'when merchant exists' do
      let(:merchant) { create(:merchant) }
      let(:email) { merchant.user.email }

      it 'it finds merchant' do
        ctx = interactor.call
        expect(ctx.resource).to eq(merchant.user)
      end

      it 'it defines role' do
        ctx = interactor.call
        expect(ctx.role).to eq(merchant.user.userable_type)
      end

      it 'it initialize token' do
        ctx = interactor.call
        expect(ctx.token).to eq(token)
      end
    end

    context 'when user does not exist' do
      it 'it returns errors' do
        ctx = interactor.call
        expect(ctx.errors[:server]).to include("Couldn't find User")
      end
    end
  end
end
