class ReviewComment < ApplicationRecord
  extend Enumerize

  belongs_to :user, inverse_of: :review_comments
  belongs_to :review_request, inverse_of: :review_comments

  validates :body, presence: true, length: { maximum: 10000 }

  enumerize :state, in: { commented: 0, change_request: 1, rereview_request: 2, approved: 3, resolved: 4, closed: 5 }
end
