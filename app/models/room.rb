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

class Room < ApplicationRecord
  belongs_to :reviewer, class_name: "User", inverse_of: :owned_rooms
  has_many :participations, foreign_key: "participating_room_id", dependent: :destroy, inverse_of: :participating_room
  has_many :reviewees, class_name: "User", through: :participations
  has_many :review_assigns, class_name: "ReviewRequest", dependent: :destroy, inverse_of: :room
  has_many :skills, as: :languageable, dependent: :destroy
  has_many :languages, through: :skills

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :capacity, numericality: { greater_than_or_equal_to: 1 }
  validate :capacity_greater_than_or_equal_to_participants

  def status_for(user)
    case
    when user.own?(self)
      "所有者"
    when user.participating?(self)
      "参加中"
    when over_capacity?
      "満室"
    else
      "参加可能"
    end
  end

  def over_capacity?
    capacity <= reviewees.size
  end

  private

    def capacity_greater_than_or_equal_to_participants
      return if capacity.blank?

      if capacity < reviewees.size
        errors.add(:capacity, "は参加者数以上の値にしてください")
      end
    end
end
