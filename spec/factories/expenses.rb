FactoryBot.define do
  factory :expense do
    user
    category
    account
    sequence(:amount) { |n| 1000 * n }
    sequence(:description) { |n| "Comment #{n}" }
    payment_at { Time.now }
  end

  factory :invalid_expense, class: 'Expense' do
    user { nil }
    category { nil }
    account { nil }
    amount { nil }
    description { nil }
    payment_at { nil }
  end
end
