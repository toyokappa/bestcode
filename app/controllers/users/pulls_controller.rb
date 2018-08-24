class Users::PullsController < ApplicationController
  before_action :set_title

  def show
    @repo = current_user.repos.find(params[:repo_id])
    @pull = @repo.pulls.find(params[:id])
  end

  def info
    pull = Pull.find_by(id: params[:id])
    pull_info = pull ? { name: pull.name, desc: pull.description } : { name: "", desc: "" }
    render json: pull_info
  end

  private

    def set_title
      @title = "プルリクエスト"
    end
end
