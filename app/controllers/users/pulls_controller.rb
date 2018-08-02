class Users::PullsController < ApplicationController
  def show
    @repo = current_user.repos.find(params[:repo_id])
    @pull = @repo.pulls.find(params[:id])
  end
end
