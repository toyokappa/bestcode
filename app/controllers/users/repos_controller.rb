class Users::ReposController < ApplicationController
  before_action :set_user, only: [:index, :show]

  def index
    @repos = @user.repos.order(pushed_at: :desc)
  end

  def show
    @repo = @user.repos.find_by(name: params[:repo_name])
    @pulls = @repo.pulls.order(created_at: :desc)
  end

  def update
    SyncReposAndPullRequestsJob.perform_later(current_user)
    flash[:success] = "GitHubとの同期を開始しました。少々時間をおいてからリロードしてください"
    redirect_to users_repos_path(current_user.name)
  end

  private

    def set_user
      @user = User.find_by(name: params[:user_name])
    end
end
