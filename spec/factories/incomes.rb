FactoryBot.define do
  factory :income do
    user
    category
    account
    sequence(:amount) { |n| 10_000 * n }
    sequence(:description) { |n| "Comment #{n}" }
    payment_at { Time.now }
  end

  factory :invalid_income, class: 'Income' do
    user { nil }
    category { nil }
    account { nil }
    amount { nil }
    description { nil }
    payment_at { nil }
  end
end
