class Users::Rooms::ReviewRequestsController < ApplicationController
  before_action :set_title
  before_action :set_review_req, only: [:edit, :update]
  before_action :set_room, only: [:new, :create, :update]
  before_action :set_collections, only: [:new, :edit]

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
  end

  def create
    @review_req = current_user.review_requests.build(review_req_params)
    if @review_req.save
      ReviewRequestMailer.open(@review_req).deliver_later
      redirect_to users_rooms_review_request_path(@room, @review_req), success: "レビューリクエストの作成に成功しました"
    else
      set_collections
      render "new"
    end
  end

  def edit
  end

  def update
    if @review_req.update(review_req_params)
      redirect_to users_rooms_review_request_path(@room, @review_req), success: "レビューリクエストを更新しました"
    else
      set_collections
      render "edit"
    end
  end

  private

    def set_title
      @title = "レビューリクエスト"
    end

    def review_req_params
      params.require(:review_request).permit(:name, :is_open, :pull_id, :room_id)
    end

    def set_review_req
      @review_req = current_user.review_requests.find(params[:id])
    end

    def set_room
      @room = current_user.participating_rooms.find(params[:room_id])
    end

    def set_collections
      # pullとroomの選択肢
      @pull_collection = current_user.pulls.with_hooked_repos.order(created_at: :desc).map {|pull| [pull.name, pull.id] }
      @room_collection = current_user.participating_rooms.map {|room| [room.name, room.id] }
    end
end
