class Users::ReposController < ApplicationController
  def index
    @repos = current_user.repos.order(pushed_at: :desc)
  end

  def show
    @repo = current_user.repos.find(params[:id])
    @pulls = @repo.pulls.order(created_at: :desc)
  end

  def update
    SyncReposAndPullsJob.perform_later(current_user)
    flash[:success] = "GitHubとの同期を開始しました。少々時間をおいてからリロードしてください"
    redirect_to users_repos_path
  end
end
