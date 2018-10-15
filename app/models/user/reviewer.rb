module User::Reviewer
  extend ActiveSupport::Concern

  def own?(room)
    self == room.reviewer
  end

  def active_state_count_for_reviewer
    review_assigns.where(state: :wait_review, is_open: true).count
  end
end
