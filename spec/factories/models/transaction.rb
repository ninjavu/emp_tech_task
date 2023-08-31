# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    merchant
    amount { 100 }
    status { :approved }
    sequence(:customer_email) { |n| "person-#{n}@example.com" }
    customer_phone { '11111111111' }
    type { 'Transaction::Reversal' }

    trait :error do
      status { :error }
    end

    trait :approved do
      status { :approved }
    end

    trait :reversed do
      status { :reversed }
    end

    trait :type_authorized do
      type { 'Transaction::Authorize' }
    end

    trait :type_charge do
      type { 'Transaction::Charge' }
    end

    trait :type_refund do
      type { 'Transaction::Refund' }
    end

    trait :type_reversal do
      type { 'Transaction::Reversal' }
    end

    trait :approved_charge do
      status { :approved }
      type { 'Transaction::Charge' }
    end
  end
end

# # frozen_string_literal: true

# FactoryBot.define do
#   factory :transaction do
#     merchant
#     amount { 100 }
#     status { :approved }
#     customer_email { 'test@test.com' }
#     customer_phone { '11111111111' }
#     transaction_reference { nil }
#     type { 'Transaction::Reversal' }

#     trait :approved do
#       status { :approved }
#     end

#     trait :reversed do
#       status { :reversed }
#     end

#     trait :type_authorized do
#       type { 'Transaction::Authorize' }
#     end

#     trait :type_charge do
#       type { 'Transaction::Charge' }
#     end

#     trait :type_refund do
#       type { 'Transaction::Refund' }
#     end

#     trait :type_reversal do
#       type { 'Transaction::Reversal' }
#     end
#   end
# end