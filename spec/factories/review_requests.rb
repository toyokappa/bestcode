# == Schema Information
#
# Table name: review_requests
#
#  id          :bigint(8)        not null, primary key
#  name        :string(255)
#  description :text(65535)
#  is_open     :boolean          default(TRUE), not null
#  state       :integer          default("wait_review"), not null
#  pull_id     :integer
#  reviewee_id :integer
#  room_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

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
