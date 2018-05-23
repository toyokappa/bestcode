class Users::Pulls::ReviewRequestsController < ApplicationController
  def new
    @pull = current_user.pull_requests.find(params[:pull_id])
    @review_req = current_user.review_requests.build(name: @pull.name, description: @pull.description, pull_request_id: @pull.id)
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
