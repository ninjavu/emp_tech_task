# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::ParamsCreator, type: :service do
  subject(:service) { described_class.new(request:) }

  let(:body) { { test: 'test' } }
  let(:type) { nil }

  let(:request) do
    OpenStruct.new(
      body: OpenStruct.new(read: body),
      headers: { 'Content-Type' => type }
    )
  end

  describe '#call' do
    context 'when json' do
      let(:body) { { test: 'test' }.to_json }

      it 'parses correctly' do
        result = service.call
        expect(result[:test]).to eq('test')
      end

      it 'returns instance of ActionController::Parameters' do
        result = service.call
        expect(result.class).to be(ActionController::Parameters)
      end
    end
  end

  describe '#call' do
    context 'when xml' do
      let(:body) { "<transaction>\n   <test>test</test>\n</transaction>" }
      let(:type) { 'application/xml' }

      it 'parses correctly' do
        result = service.call
        expect(result[:test]).to eq('test')
      end

      it 'returns instance of ActionController::Parameters' do
        result = service.call
        expect(result.class).to be(ActionController::Parameters)
      end
    end
  end
end
