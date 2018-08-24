class Users::ReposController < ApplicationController
  before_action :set_title

  def index
    @repos = current_user.my_repos.order(pushed_at: :desc)
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
    @title = "リポジトリ詳細"
    @repo = current_user.repos.find(params[:id])
    @pulls = @repo.pulls.where(is_open: true).order(created_at: :desc)
  end

  def update
    SyncReposJob.perform_later(current_user)
    flash[:success] = "GitHubとの同期を開始しました。少々時間をおいてからリロードしてください"
    redirect_to users_repos_path
  end

  private

    def set_title
      @title = "リポジトリ"
    end
end
