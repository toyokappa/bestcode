FactoryBot.define do
  factory :user do
    provider "MyString"
    uid "MyString"
    name "MyString"
    email "MyString"
    contribution 1
    is_reviewer false
  end
end
