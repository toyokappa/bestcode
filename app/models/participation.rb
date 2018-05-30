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

class Participation < ApplicationRecord
  belongs_to :participating_room, class_name: "Room", inverse_of: :participations
  belongs_to :reviewee, class_name: "User", inverse_of: :participations
end
