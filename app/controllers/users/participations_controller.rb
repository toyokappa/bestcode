class Users::ParticipationsController < ApplicationController
  before_action :set_room
  before_action :check_evaluable_room, only: [:destroy]

  def update
    check_participation_condition(@room)
    RoomMailer.participate(@room, current_user).deliver_later
    redirect_to users_room_chats_path(@room)
  end

  def destroy
    current_user.leave(@room)
    RoomMailer.leave(@room, current_user).deliver_later
    redirect_to users_room_path(@room), success: t(".leaving_success", name: @room.name)
  end

  private

    def set_room
      @room = Room.find(params[:id])
    end

    def check_participation_condition(room)
      case
      when current_user.own?(room)
        flash[:danger] = t(".room_owener_error")
      when current_user.participating?(room)
        flash[:danger] = t(".already_participated_error")
      when room.over_capacity?
        flash[:danger] = t(".over_capacity_error")
      else
        current_user.join(room)
        flash[:success] = t(".participation_success", name: room.name)
      end
    end

    def check_evaluable_room
      unless current_user.evaluated?(@room)
        flash[:success] = "退出前にルームの評価をしてください（退出処理は完了していません）"
        redirect_to new_users_room_evaluation_path(@room, referer: :leave_room)
      end
    end
end
