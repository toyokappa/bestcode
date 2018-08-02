class Users::ReposController < ApplicationController
  def index
    @repos = current_user.repos.where(is_hook: true).order(pushed_at: :desc)
  end

  def new
    @repos = current_user.repos.order(pushed_at: :desc)
  end

  def create
    repo = current_user.repos.find(params[:id])
    CreateWebhooksJob.perform_now(current_user, repo)
    redirect_to users_repos_path, success: "#{repo.full_name}をMyリポジトリに追加しました"
  end

  def show
    @repo = current_user.repos.find(params[:id])
    @pulls = @repo.pulls.where(is_open: true).order(created_at: :desc)
  end

  def update
    SyncReposAndPullsJob.perform_later(current_user)
    flash[:success] = "GitHubとの同期を開始しました。少々時間をおいてからリロードしてください"
    redirect_to users_repos_path
  end
end
