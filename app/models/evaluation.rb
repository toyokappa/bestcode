class Evaluation < ApplicationRecord
  belongs_to :reviewee, class_name: "User", inverse_of: :evaluations
  belongs_to :room, inverse_of: :evaluations

  validates :speed, presence: true
  validates :quantity, presence: true
  validates :quality, presence: true

  def score(round = nil)
    score = (speed + quantity + quality).to_f / 3
    round ? score.round(round) : score
  end
end
