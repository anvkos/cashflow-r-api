FactoryBot.define do
  factory :currency do
    name { Faker::Currency.name }
    code { Faker::Currency.code }
    symbol { Faker::Currency.symbol }

    trait :rub do
      name { 'Российский рубль' }
      code { 'RUB' }
      symbol { 'руб.'}
    end

    trait :usd do
      name { 'United States dollar' }
      code { 'USD' }
      symbol { '$'}
    end

    trait :euro do
      name { 'Euro' }
      code { 'EUR' }
      symbol { '€'}
    end
  end
end
