# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    name { 'test merchant' }
    description { 'test merchant description' }
    status { :active }

    trait :active do
      status { :active }
    end

    trait :inactive do
      status { :inactive }
    end

    trait :with_approved_charged_transactions do
      after(:create) do |merchant|
        create(:transaction, :approved_charge, merchant:)
      end
    end

    after(:create) do |merchant|
      create(:user, userable: merchant)
    end
  end
end
