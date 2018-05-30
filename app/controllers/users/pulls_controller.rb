class Users::PullsController < ApplicationController
  def show
    @user = User.find_by!(name: params[:user_name])
    @repo = @user.repos.find_by!(name: params[:repo_name])
    @pull = @repo.pulls.find(params[:pull_id])
  end

  def update
    repo = current_user.repos.find(params[:repo_id])
    SyncPullsJob.perform_later(current_user, repo)
    flash[:success] = "GitHubとの同期を開始しました。少々時間をおいてからリロードしてください"
    redirect_to users_repo_path(current_user.name, repo.name)
  end
end
