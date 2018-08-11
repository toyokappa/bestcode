class Users::ProfilesController < ApplicationController
  def show
    @user = User.find_by!(name: params[:name])
    @rooms = @user.owned_rooms.where(is_open: true)
    @rooms = @user.participating_rooms.where(is_open: true) if params[:room_type] == "participating"
  end
end
