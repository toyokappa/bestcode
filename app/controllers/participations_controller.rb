class ParticipationsController < ApplicationController
  before_action :set_room

  def update
    case
    when current_user == @room.reviewer
      redirect_to @room, danger: "ルームの所有者のため参加できません"
    when current_user.participating_rooms.exists?(@room.id)
      redirect_to @room, danger: "既にルームに所属しています"
    when @room.reviewees.count >= @room.capacity
      redirect_to @room, danger: "参加上限人数に達しているため参加できません"
    else
      @room.reviewees << current_user
      redirect_to @room, success: "ルームに参加しました"
    end
  end

  def destroy
    @room.reviewees.destroy(current_user)
    redirect_to @room, success: "ルームから退出しました"
  end

  private

    def set_room
      @room = Room.find(params[:id])
    end
end
