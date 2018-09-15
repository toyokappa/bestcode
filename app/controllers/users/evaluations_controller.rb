class Users::EvaluationsController < ApplicationController
  before_action :set_title
  before_action :set_room
  before_action :check_evaluation

  def new
    @evaluation = current_user.evaluations.build(room: @room)
  end

  def create
    @evaluation = current_user.evaluations.build(evaluation_params)
    if @evaluation.save
      return redirect_to users_room_path(@room), success: "評価が完了しました" unless params[:referer] == "leave_room"

      @room.reviewees.destroy(current_user)
      RoomMailer.leave_with_evaluation(@room, current_user, @evaluation).deliver_later
      redirect_to users_rooms_path, success: "評価が完了し、ルームを退出しました"
    else
      render "new"
    end
  end

  private

    def set_title
      @title = "レビュワー評価"
    end

    def evaluation_params
      params.require(:evaluation).permit(:speed, :quantity, :quality, :comment, :user_id, :room_id)
    end

    def set_room
      @room = Room.find(params[:room_id])
    end

    def check_evaluation
      redirect_to users_room_path(@room), danger: "こちらのルームは評価済みです" if current_user.evaluated?(@room)
    end
end
