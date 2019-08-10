FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category_#{n}" }
  end

  factory :invalid_category, class: 'Category' do
    name { nil }
  end
end
