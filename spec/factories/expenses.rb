FactoryBot.define do
  factory :expense do
    user
    category
    account
    amount { 1000 }
    description { "MyString" }
    payment_at { Time.now }
  end

  factory :invalid_expense, class: 'Expense' do
    user { nil }
    category { nil }
    account { nil }
    amount { 1 }
    description { "MyString" }
    payment_at { "2019-08-14 14:50:28" }
  end
end
