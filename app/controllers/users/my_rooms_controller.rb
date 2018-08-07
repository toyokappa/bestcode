class Users::MyRoomsController < ApplicationController
  def index
    @reviewer_rooms =
      case params[:open_state]
      when "closed"
        current_user.owned_rooms.where(is_open: false)
      when "all"
        current_user.owned_rooms
      else
        current_user.owned_rooms.where(is_open: true)
      end

    @reviewee_rooms = current_user.participating_rooms
  end
end
