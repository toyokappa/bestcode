class Users::PullsController < ApplicationController
  before_action :set_title

  def show
    @repo = current_user.repos.find(params[:repo_id])
    @pull = @repo.pulls.find(params[:id])
  end

  private

    def set_title
      @title = "プルリクエスト"
    end
end
