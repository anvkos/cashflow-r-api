FactoryBot.define do
  factory :account do
    user
    currency
    name { 'Visa green' }
    amount { 1000 }
  end

  factory :invalid_account do
    user { nil }
    currency { nil }
    name { nil }
    amount { 'trulala' }
  end
end
