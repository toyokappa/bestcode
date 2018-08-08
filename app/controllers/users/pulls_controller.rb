class Users::PullsController < ApplicationController
  def show
    @repo = current_user.repos.find(params[:repo_id])
    @pull = @repo.pulls.find(params[:id])
  end

  def info
    pull = Pull.find_by(id: params[:id])
    pull_info = pull ? { name: pull.name, desc: pull.description } : { name: "", desc: "" }
    render json: pull_info
  end
end
