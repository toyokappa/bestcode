# == Schema Information
#
# Table name: rooms
#
#  id          :bigint(8)        not null, primary key
#  name        :string(255)
#  description :text(65535)
#  capacity    :integer
#  reviewer_id :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :room do
    name "MyString"
    description "MyText"
    capacity 1
    reviewer_id 1
  end
end
