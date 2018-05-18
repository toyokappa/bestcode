class Participation < ApplicationRecord
  belongs_to :participating_room, class_name: "Room", inverse_of: :participations
  belongs_to :reviewee, class_name: "User", inverse_of: :participations
end
