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
      states = I18n.t("enumerize.review_comment.state").to_h
      if user == room.reviewer
        target_keys = review_req.wait_review? ? [:commented, :change_request, :approved] : [:commented]
      else
        target_keys =
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

        target_keys = [:commented, :reopen] if !review_req.is_open && !review_req.resolved?
      end

      states.select {|key, _| target_keys.include?(key) }.invert
    end
  end
end
