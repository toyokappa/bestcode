class Users::Reviewers::ReviewRequestsController < ApplicationController
  def new
    @reviewer = current_user.reviewers.find(params[:reviewer_id])
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
