class Users::MyRoomsController < ApplicationController
  def index
    @reviewer_rooms = current_user.owned_rooms
    @reviewee_rooms = current_user.participating_rooms
  end
end
