class HooksController< ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user

  def pulls
    payload = JSON.load(params[:payload])
    user = User.find_by!(uid: payload["repository"]["owner"]["id"])
    repo = user.repos.find(payload["repository"]["id"])
    SyncPullsJob.perform_later(user, repo)
  end
end
