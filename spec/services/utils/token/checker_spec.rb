# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Utils::Token::Checker, type: :service do
  subject(:service) { described_class.new }

  let(:expiration) { Time.now.utc + 1.day }

  describe 'expiration check' do
    context 'when success' do
      it 'does not throw error' do
        expect { service.call(expiration:) }.not_to raise_error(::JWT::DecodeError, 'Token has expired')
      end

      it 'returns nil' do
        expect(service.call(expiration:)).to be(nil)
      end
    end

    context 'when expired' do
      let(:expiration) { Time.now.utc - 1.day }

      it 'throws error' do
        expect { service.call(expiration:) }.to raise_error(::JWT::DecodeError, 'Token has expired')
      end
    end
  end
end
