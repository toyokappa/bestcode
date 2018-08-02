class Users::Rooms::ReviewRequestsController < ApplicationController
  def show
    @room = Room.find(params[:room_id])
    # TODO: review_requestsのnumを追加し、numで検索したい
    @review_req = @room.review_assigns.find(params[:id])
    @review_comments = @review_req.review_comments
    @review_comment = current_user.review_comments.build(review_request_id: @review_req)
  end

  def new
    @room = current_user.participating_rooms.find(params[:room_id])
    @review_req = current_user.review_requests.build(room_id: @room.id)

    # pullとroomの選択肢
    @pull_collection = current_user.pulls.with_hooked_repos.order(created_at: :desc).map {|pull| [pull.name, pull.id] }
    @room_collection = current_user.participating_rooms.map {|room| [room.name, room.id] }
  end

  def create
    @review_req = current_user.review_requests.build(review_req_params)
    if @review_req.save
      redirect_to users_rooms_review_request_path(@review_req.room, @review_req), success: "レビューリクエストの作成に成功しました"
    else
      @room = current_user.participating_rooms.find(params[:room_id])

      # pullとroomの選択肢
      @pull_collection = current_user.pulls.with_hooked_repos.order(created_at: :desc).map {|pull| [pull.name, pull.id] }
      @room_collection = current_user.participating_rooms.map {|room| [room.name, room.id] }
      render "new"
    end
  end

  private

    def review_req_params
      params.require(:review_request).permit(:name, :description, :is_open, :pull_id, :room_id)
    end
end
