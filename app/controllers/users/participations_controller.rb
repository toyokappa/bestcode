class Users::ParticipationsController < ApplicationController
  before_action :set_room

  def update
    case
    when current_user == @room.reviewer
      redirect_to users_room_path(@room), danger: t(".room_owener_error")
    when current_user.participating_rooms.exists?(@room.id)
      redirect_to users_room_path(@room), danger: t(".already_participated_error")
    when @room.reviewees.count >= @room.capacity
      redirect_to users_room_path(@room), danger: t(".over_capacity_error")
    else
      @room.reviewees << current_user
      redirect_to users_room_path(@room), success: t(".participation_success", name: @room.name)
    end
  end

  def destroy
    @room.reviewees.destroy(current_user)
    redirect_to users_room_path(@room), success: t(".leaving_success", name: @room.name)
  end

  private

    def set_room
      @room = Room.find(params[:id])
    end
end
