class ReviewComment < ApplicationRecord
  extend Enumerize

  belongs_to :user, inverse_of: :review_comments
  belongs_to :review_request, inverse_of: :review_comments

  enumerize :state, in: [:commented, :change_request, :rereview_request, :approved, :resolved, :closed, :reopen], predicates: true

  validates :body, presence: true, if: :commented?
  validates :body, length: { maximum: 10000 }
end
