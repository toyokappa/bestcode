class Users::EvaluationsController < ApplicationController
  before_action :set_title
  before_action :set_room
  before_action :set_evaluation, only: [:edit, :update]
  before_action :check_evaluation, only: [:new, :create, :skip]

  def new
    @evaluation = current_user.evaluations.build(room: @room)
  end

  def create
    @evaluation = current_user.evaluations.build(evaluation_params)
    return render :new unless @evaluation.save
    return redirect_to users_room_path(@room), success: "評価が完了しました" unless params[:referer] == "leave_room"

    current_user.leave(@room)
    RoomMailer.leave_with_evaluation(@room, current_user, @evaluation).deliver_later
    redirect_to users_room_path(@room), success: "評価が完了し、ルームを退出しました"
  end

  def edit
  end

  def update
    return render :edit unless @evaluation.update(evaluation_params)

    # RoomMailer.update_evaluation(@room, current_user, @evaluation).deliver_later
    redirect_to users_room_path(@room), success: "評価を変更しました"
  end

  def skip
    current_user.leave(@room)
    RoomMailer.leave(@room, current_user).deliver_later
    redirect_to users_room_path(@room), success: t(".leaving_success", name: @room.name)
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

    def set_evaluation
      @evaluation = current_user.evaluations.find(params[:id])
    end

    def check_evaluation
      redirect_to users_room_path(@room), danger: "こちらのルームは評価済みです" if current_user.evaluated?(@room)
    end
end
