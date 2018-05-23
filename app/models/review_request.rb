class ReviewRequest < ApplicationRecord
  extend Enumerize

  belongs_to :pull_request, inverse_of: :review_requests
  belongs_to :reviewee, class_name: "User", inverse_of: :review_requests
  belongs_to :reviewer, class_name: "User", inverse_of: :review_requests

  validates :name, presence: true, length: { maximum: 1000 }
  validates :description, length: { maximum: 10000 }
  validates :is_open, inclusion: { in: [true, false] }
  validates :state, presence: true
  validates :pull_request_id, presence: true
  validates :reviewee_id, presence: true
  validates :reviewer_id, presence: true

  enumerize :state, in: { wait_review: 0, change_request: 1, approved: 2 }
end
