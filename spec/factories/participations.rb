# == Schema Information
#
# Table name: participations
#
#  id                    :bigint(8)        not null, primary key
#  participating_room_id :bigint(8)
#  reviewee_id           :bigint(8)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

FactoryBot.define do
  factory :participation do
    room_id 1
    reviewee_id 1
  end
end
