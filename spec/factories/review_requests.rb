FactoryBot.define do
  factory :review_request do
    name "MyString"
    description "MyText"
    state 1
    pull_request nil
    reviewee nil
    reviewer nil
  end
end
