# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Utils::Token::Initializer, type: :service do
  subject(:service) { described_class.new }

  let(:resource) { create(:admin) }
  let(:secret) { '11111111' }

  describe 'call' do
    context 'when success' do
      it 'returns jwt token' do
        token = service.call(resource:)
        expect(token).to be_a(String)
      end
    end

    context 'when failed' do
      let(:resource) { nil }

      it 'returns jwt token' do
        expect { service.call(resource:) }.to raise_error
      end
    end
  end
end
