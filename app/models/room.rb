class Room < ApplicationRecord
  belongs_to :reviewer, class_name: "User", inverse_of: :owned_rooms
  has_many :participations, foreign_key: "participating_room_id", dependent: :destroy, inverse_of: :participating_room
  has_many :reviewees, class_name: "User", through: :participations
  has_many :review_assigns, class_name: "ReviewRequest", dependent: :destroy, inverse_of: :room

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :capacity, numericality: { greater_than_or_equal_to: 1 }
  validate :capacity_greater_than_or_equal_to_participants

  def status_for(user)
    case
    when reviewer == user
      "所有者"
    when reviewees.exists?(user.id)
      "参加中"
    when capacity <= reviewees.size
      "満室"
    else
      "参加可能"
    end
  end

  private

    def capacity_greater_than_or_equal_to_participants
      return if capacity.blank?

      if capacity < reviewees.size
        errors.add(:capacity, "は参加者数以上の値にしてください")
      end
    end
end
