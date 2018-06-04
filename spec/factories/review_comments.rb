FactoryBot.define do
  factory :review_comment do
    body "MyText"
    state 1
    user_id 1
    review_request_id 1
  end
end
