# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person-#{n}@example.com" }

    trait :merchant do
      association :userable, factory: :merchant
    end

    trait :admin do
      association :userable, factory: :admin
    end
  end
end
