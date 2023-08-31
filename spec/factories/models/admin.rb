# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    name { 'test admin' }
    description { 'test admin description' }
    status { :active }

    trait :active do
      status { :active }
    end

    trait :inactive do
      status { :inactive }
    end

    after(:create) do |admin|
      create(:user, userable: admin)
    end
  end
end
