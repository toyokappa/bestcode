class Users::Rooms::ReviewRequestsController < ApplicationController
  def new
    @room = current_user.participating_rooms.find(params[:room_id])
    @review_req = current_user.review_requests.build(room_id: @room.id)
  end

  def create
    @review_req = current_user.review_requests.build(review_req_params)
    if @review_req.save
      redirect_to users_room_path(@review_req.room), success: "レビューリクエストの作成に成功しました"
    else
      render "new"
    end
  end

  private

    def review_req_params
      params.require(:review_request).permit(:name, :description, :is_open, :pull_id, :room_id)
    end
end
