class Users::Rooms::EvaluationsController < ApplicationController
  before_action :set_room
  before_action :check_evaluation

  def new
    @evaluation = current_user.evaluations.build(room: @room)
  end

  def create
    @evaluation = current_user.evaluations.build(evaluation_params)
    if @evaluation.save
      if params[:referer] == "leave_room"
        @room.close!
        redirect_to users_rooms_path, success: "評価が完了し、ルームを退出しました"
      else
        redirect_to users_room_path(@room), success: "評価が完了しました"
      end
    else
      render "new"
    end
  end

  private

    def evaluation_params
      params.require(:evaluation).permit(:speed, :quantity, :quality, :comment, :user_id, :room_id)
    end

    def set_room
      @room = Room.find(params[:room_id])
    end

    def check_evaluation
      if current_user.evaluated?(@room)
        redirect_to users_room_path(@room), danger: "こちらのルームは評価済みです"
      end
    end
end
