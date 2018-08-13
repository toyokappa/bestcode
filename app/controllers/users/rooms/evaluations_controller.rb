class Users::Rooms::EvaluationsController < ApplicationController
  before_action :set_room
  # before_action :check_evaluation

  def new
    @evaluation = current_user.evaluations.build(room: @room)
  end

  def create
    @evaluation = current_user.evaluations.build(evaluation_params)
    if @evaluation.save
      redirect_to users_room_path(@room), success: "評価が完了しました"
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
      evaluation = current_user.evaluations.find_by(room: @room)
      if evaluation.present?
        # TODO: 遷移元がルームクローズだった場合、メッセージを"退出しました"に変更
        redirect_to users_room_path(@room), danger: "こちらのルームは評価済みです"
      end
    end
end
