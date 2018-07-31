class HooksController< ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user

  def pulls
    repository = params[:repository]
    user = User.find_by!(uid: repository[:owner][:id])
    repo = user.repos.find(repository[:id])
    SyncPullsJob.perform_later(user, repo)
    render json: { message: :ok }
  end
end
