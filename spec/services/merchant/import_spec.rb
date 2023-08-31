# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant::Import, type: :service do
  subject(:service) { described_class.new }

  file_name = "#{Rails.root}/spec/files/merchants.csv"

  describe 'call' do
    it 'Should creates merchants' do
      service.call(file_name:)
      expect(Merchant.count).to be(4)
    end

    it 'Should skip failed records' do
      service.call(file_name:)
      expect(Merchant.where(name: 'Merchant 3')).to be_empty
    end
  end
end
