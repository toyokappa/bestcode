class Users::ReviewCommentsController < ApplicationController
  before_action :set_review_vars, only: [:update, :destroy]

  def create
    @set_title = "レビューリクエスト"
    @review_comment = current_user.review_comments.build(create_review_comment_params)
    @review_req = @review_comment.review_request
    @review_comments = @review_req.review_comments
    @room = @review_req.room
    if @review_comment.save
      @review_req.change_state(@review_comment)
      flash[:success] = "コメントしました"
      redirect_to users_rooms_review_request_path(@room, @review_req)
    else
      render "users/rooms/review_requests/show"
    end
  end

  def update
    @review_comment.update!(update_review_comment_params)
    flash[:success] = "コメントを更新しました"
    redirect_to users_rooms_review_request_path(@room, @review_req)
  end

  def destroy
    if @review_comment == @review_req.review_comments.where.not(state: :commented).last
      @review_req.rollback_state(@review_comment)
    end
    @review_comment.destroy!
    redirect_to users_rooms_review_request_path(@room, @review_req)
  end

  private

    def create_review_comment_params
      params.require(:review_comment).permit(:body, :state, :review_request_id)
    end

    def update_review_comment_params
      params.require(:review_comment).permit(:body)
    end

    def set_review_vars
      @review_comment = current_user.review_comments.find(params[:id])
      @review_req = @review_comment.review_request
      @room = @review_req.room
    end
end
