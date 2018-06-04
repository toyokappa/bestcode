class Users::PullsController < ApplicationController
  def show
    @repo = current_user.repos.find(params[:repo_id])
    @pull = @repo.pulls.find(params[:id])
  end

  def update
    repo = current_user.repos.find(params[:repo_id])
    SyncPullsJob.perform_later(current_user, repo)
    flash[:success] = "GitHubとの同期を開始しました。少々時間をおいてからリロードしてください"
    redirect_to users_repo_path(repo)
  end
end
