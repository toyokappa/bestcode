class Users::RepositoriesController < ApplicationController
  before_action :set_user, only: [:index, :show]

  def index
    @repos = @user.repositories
  end

  def show
    @repo = @user.repositories.find_by(name: params[:name])
    @pulls = @repo.pull_requests
  end

  def update
    SyncRepositoriesAndPullRequestsJob.perform_later(current_user)
    flash[:success] = "GitHubとの同期を開始しました。少々時間をおいてからリロードしてください"
    redirect_to user_repositories_path(current_user.name)
  end

  private

    def set_user
      @user = User.find_by(name: params[:user_name])
    end
end
