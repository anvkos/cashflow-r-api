FactoryBot.define do
  factory :jwt_blacklist do
    jti { "MyString" }
    exp { "2019-08-09 14:35:31" }
  end
end
