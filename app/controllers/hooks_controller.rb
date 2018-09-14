class HooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user

  def pulls
    repository = params[:repository]
    user = User.find_by!(uid: repository[:owner][:id])
    repo = user.repos.find(repository[:id])
    SyncPullsJob.perform_later(user, repo)

    # 現状は問題ないが、リクエストが増えた際にバックグラウンドに回す方が良いかも
    if request.headers["HTTP_X_GITHUB_EVENT"] == "pull_request" && params[:action] == "closed"
      pull = Pull.find_by(id: params[:pull_request][:id])
      return render json: { message: "no pulls" } unless pull

      if params[:pull_request][:merged]
        pull.review_requests.find_each {|rr| rr.update(state: :resolved, is_open: false) }
      else
        pull.review_requests.find_each {|rr| rr.update(is_open: false) }
      end
    end
    render json: { message: :ok }
  end

  def state
    return render json: { message: :pong } if request.headers["HTTP_X_GITHUB_EVENT"] == "ping"

    reviewer = User.find_by!(uid: params[:review][:user][:id])
    pull = Pull.find(params[:pull_request][:id])

    # NOTE: システム上、1つのpullから同じreviewerに複数レビュリクが
    #       作成されないことを仮定して、下記を実装
    review_req = reviewer.review_assigns.find_by!(pull_id: pull.id)
    review_req.update!(state: params[:review][:state])
    render json: { message: :ok }
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Not State Changes on BestCode." }
  end
end
