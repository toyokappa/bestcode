class ReviewComment < ApplicationRecord
  extend Enumerize

  belongs_to :user, inverse_of: :review_comments
  belongs_to :review_request, inverse_of: :review_comments

  enumerize :state, in: [:commented, :change_request, :rereview_request, :approved, :resolved, :closed, :reopen], predicates: true

  validates :body, presence: true, if: :commented?
  validates :body, length: { maximum: 10000 }
  validates :state, presence: true

  class << self
    def selectable_state(user, room, review_req)
      if user == room.reviewer
        if review_req.state == :wait_review
          [:commented, :change_request, :approved]
        else
          [:commented]
        end
      else
        return [:commented, :reopen] if !review_req.is_open && !review_req.resolved?

        case review_req.state.to_sym
        when :change_request
          [:commented, :rereview_request, :closed]
        when :approved
          [:commented, :resolved]
        when :resolved
          [:commented]
        else
          [:commented, :closed]
        end
      end
    end
  end
end
