class Users::Rooms::ReviewRequestsController < ApplicationController
  def new
    room = current_user.participating_rooms.find(params[:room_id])
    @reviewer = room.reviewer
    @review_req = current_user.review_requests.build(reviewer_id: @reviewer.id)
  end

  def create
    @review_req = current_user.review_requests.build(review_req_params)
    if @review_req.save
      redirect_to root_path, success: "レビューリクエストの作成に成功しました"
    else
      render "new"
    end
  end

  private

    def review_req_params
      params.require(:review_request).permit(:name, :description, :is_open, :pull_request_id, :reviewer_id)
    end
end
