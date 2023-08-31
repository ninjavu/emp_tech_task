# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Utils::Token::Parser, type: :service do
  subject(:service) { described_class.new }

  let(:token) { nil }

  describe 'parsing' do
    context 'when token and resource exist' do
      let(:resource) { create(:merchant) }
      let(:token) { Utils::Token::Initializer.new.call(resource:) }

      it 'it pareses resource id' do
        result = service.call(token:)
        expect(result[:resource_id]).to eq(resource.id)
      end

      it 'it pareses resource expiration' do
        result = service.call(token:)
        expect(result[:expiration]).to be_present
      end
    end

    context 'when resource does not exist' do
      let(:token) { Utils::Token::Initializer.new.call(resource:) }

      it 'it raises error' do
        expect { service.call(token:) }.to raise_error
      end
    end

    context 'when token does not exist' do
      let(:resource) { create(:merchant) }

      it 'it raises error' do
        expect { service.call(token:) }.to raise_error
      end
    end
  end
end
