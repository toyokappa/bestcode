class Users::Rooms::ReviewCommentsController < ApplicationController
  def create
    @review_comment = current_user.review_comments.build(review_comment_params)
    @review_req = @review_comment.review_request
    @review_comments = @review_req.review_comments
    @room = @review_req.room
    if @review_comment.save
      @review_req.change_state(@review_comment.state)
      flash[:success] = "コメントしました"
      redirect_to users_rooms_review_request_path(@room, @review_req)
    else
      render "users/rooms/review_requests/show"
    end
  end

  private
  
    def review_comment_params
      params.require(:review_comment).permit(:body, :state, :review_request_id)
    end
end
