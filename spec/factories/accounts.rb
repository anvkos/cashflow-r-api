FactoryBot.define do
  factory :account do
    user { nil }
    currency { nil }
    name { "MyString" }
    amount { 1 }
  end
end
