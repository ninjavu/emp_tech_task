# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TokenCheckInteractor, type: :interactor do
  subject(:interactor) { described_class.new(token:) }

  let(:token) { '123123123' }

  describe 'check process' do
    before do
      allow(Utils::Token::Parser).to receive_message_chain(:new, :call).and_return(data)
      allow(Utils::Token::Checker).to receive_message_chain(:new, :call)
    end

    context 'when admin' do
      let(:admin) { create(:admin) }

      let(:data) do
        {
          expiration: Date.tomorrow,
          resource_type: 'Admin',
          resource_id: admin.id
        }
      end

      it 'identifies admin' do
        ctx = interactor.call
        expect(ctx.user).to eq(admin)
      end
    end

    context 'when merchant' do
      let(:merchant) { create(:merchant) }

      let(:data) do
        {
          expiration: Date.tomorrow,
          resource_type: 'Merchant',
          resource_id: merchant.id
        }
      end

      it 'identifies merchant' do
        ctx = interactor.call
        expect(ctx.user).to eq(merchant)
      end
    end

    context 'when token expired' do
      before do
        allow(Utils::Token::Checker)
          .to receive_message_chain(:new, :call)
          .and_raise(::JWT::DecodeError, 'Token has expired')
      end

      let(:admin) { create(:admin) }

      let(:data) do
        {
          expiration: Date.yesterday,
          resource_type: 'Admin',
          resource_id: admin.id
        }
      end

      it 'returns error' do
        ctx = interactor.call
        expect(ctx.errors[:server]).to include('Token has expired')
      end
    end

    context 'when invalid user' do
      let(:merchant) { nil }

      let(:data) do
        {
          expiration: Date.tomorrow,
          resource_type: 'Merchant',
          resource_id: nil
        }
      end

      it 'returns error' do
        ctx = interactor.call
        expect(ctx.errors[:server]).to include("Couldn't find Merchant without an ID")
      end
    end
  end
end
