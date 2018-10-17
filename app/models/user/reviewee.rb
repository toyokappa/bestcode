module User::Reviewee
  extend ActiveSupport::Concern

  def participatable?(room)
    !own?(room) && !participating?(room) && !room.over_capacity?
  end

  def join(room)
    self.participating_rooms << room
    join_firestore_chat(room)
  end

  def leave(room)
    participating_rooms.destroy(room)
  end

  def participating?(room)
    participating_rooms.include?(room)
  end

  def evaluated?(room)
    evaluations.find_by(room: room).present?
  end

  def active_state_count_for_reviewee
    active_state = %i[commented changes_requested approved]
    review_requests.where(state: active_state, is_open: true).count
  end
end
