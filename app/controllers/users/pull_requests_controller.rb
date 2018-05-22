class Users::PullRequestsController < ApplicationController
  def show
    @user = User.find_by!(name: params[:user_name])
    @repo = @user.repositories.find_by!(name: params[:repository_name])
    @pull = @repo.pull_requests.find(params[:id])
  end

  def update
    repo = current_user.repositories.find(params[:id])
    SyncPullRequestsJob.perform_later(current_user, repo)
    flash[:success] = "GitHubとの同期を開始しました。少々時間をおいてからリロードしてください"
    redirect_to user_repository_path(current_user.name, repo.name)
  end
end
