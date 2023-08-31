# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Import, type: :service do
  subject(:service) { described_class.new }

  file_name = "#{Rails.root}/spec/files/admins.csv"

  describe 'call' do
    it 'Should creates admins' do
      service.call(file_name:)
      expect(Admin.count).to be(4)
    end

    it 'Should skip failed records' do
      service.call(file_name:)
      expect(Admin.where(name: 'Admin 3')).to be_empty
    end
  end
end
