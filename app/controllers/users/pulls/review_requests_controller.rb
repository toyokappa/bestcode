class Users::Pulls::ReviewRequestsController < ApplicationController
  def new
    @pull = current_user.pulls.find(params[:pull_id])
    @review_req = current_user.review_requests.build(name: @pull.name, description: @pull.description, pull_id: @pull.id)

    # pullとroomの選択肢
    @pull_collection = current_user.pulls.where(is_open: true).order(created_at: :desc).map {|pull| [pull.name, pull.id] }
    @room_collection = current_user.participating_rooms.map {|room| [room.name, room.id] }
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
