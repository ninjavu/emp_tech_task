# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Internal::Context, type: :interactor do
  let(:token) { '123123123' }
  let(:params) { {} }

  describe 'initialize' do
    it 'parses attributes' do
      ctx = described_class.new(token:, params:)
      expect(ctx.token).to eq(token)
    end

    it 'adds http_status' do
      ctx = described_class.new(token:, params:)
      expect(ctx.http_status).to eq(:ok)
    end

    it 'adds empty errors array' do
      ctx = described_class.new(token:, params:)
      expect(ctx.errors).to be_empty
    end
  end
end
