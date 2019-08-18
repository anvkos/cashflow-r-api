FactoryBot.define do
  factory :account do
    user
    currency
    sequence(:name) { |n| "Card #{n}" }
    amount { 1000 }
  end

  factory :invalid_account, class: 'Account' do
    user { nil }
    currency { nil }
    name { nil }
    amount { 'trulala' }
  end
end
