class ReviewRequest < ApplicationRecord
  extend Enumerize

  belongs_to :pull, inverse_of: :review_requests
  belongs_to :reviewee, class_name: "User", inverse_of: :review_requests
  belongs_to :room, inverse_of: :review_assigns

  validates :name, presence: true, length: { maximum: 1000 }
  validates :description, length: { maximum: 10000 }
  validates :is_open, inclusion: { in: [true, false] }
  validates :state, presence: true
  validates :pull_id, presence: true
  validates :reviewee_id, presence: true
  validates :room_id, presence: true

  enumerize :state, in: { wait_review: 0, change_request: 1, approved: 2 }
end
