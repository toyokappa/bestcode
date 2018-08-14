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
  has_many :evaluations, dependent: :destroy, inverse_of: :room

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :capacity, numericality: { greater_than_or_equal_to: 1 }
  validate :capacity_greater_than_or_equal_to_participants

  mount_uploader :image, HeaderImageUploader

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

  def change_skills_by(lang_ids = [])
    unselect_ids = language_ids - lang_ids
    skills.where(language_id: unselect_ids).destroy_all

    lang_ids.each do |lang_id|
      next if skills.find_by(language_id: lang_id)

      skills.create!(language_id: lang_id)
    end
  end

  def evaluations_score(output = nil, round = nil)
    return output if evaluations.blank?

    score = evaluations.sum(&:score) / evaluations.length
    round ? score.round(round) : score
  end

  def close!
    update!(is_open: false)
  end

  def open!
    update!(is_open: true)
  end

  def active_state_count_for_reviewer
    review_assigns.where(state: :wait_review, is_open: true).count
  end

  def active_state_count_for_reviewee
    active_state = %i[change_request approved]
    review_assigns.where(state: active_state, is_open: true).count
  end

  def check_and_return_image(type = nil)
    return "/images/no_bg.jpg" if image.blank? && reviewer.header_image.blank?
    return reviewer.header_image.url if image.blank?

    type ? image.send(type).url : image.url
  end

  private

    def capacity_greater_than_or_equal_to_participants
      return if capacity.blank?

      if capacity < reviewees.size
        errors.add(:capacity, "は参加者数以上の値にしてください")
      end
    end
end
