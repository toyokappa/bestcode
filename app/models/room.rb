class Room < ApplicationRecord
  belongs_to :reviewer, class_name: "User", inverse_of: :owned_rooms
  has_many :participations, foreign_key: "participating_room_id", dependent: :destroy, inverse_of: :participating_room
  has_many :reviewees, class_name: "User", through: :participations

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :capacity, numericality: { greater_than_or_equal_to: 1 }
  validate :capacity_greater_than_or_equal_to_participants

  private

    def capacity_greater_than_or_equal_to_participants
      return if capacity.blank?

      if capacity < reviewees.size
        errors.add(:capacity, "は参加者数以上の値にしてください")
      end
    end
end
