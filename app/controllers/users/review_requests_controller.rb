class Users::ReviewRequestsController < ApplicationController
  def index
    @room = Room.find(params[:room_id])
    @open_state = params[:open_state].present? ? params[:open_state] : "open"
    @review_reqs =
      case @open_state
      when "open"
        @room.review_assigns.where(is_open: true)
      when "closed"
        @room.review_assigns.where(is_open: false)
      when "all"
        @room.review_assigns
      end
  end

  def create
    repo = current_user.repos.find_by(name: params[:repo_name])
    return render json: { status: "NO_REPOS" } unless repo
    return render json: { status: "NOT_MY_REPO" } unless repo.is_hook?

    pull = repo.pulls.find_by(number: params[:pull_num])
    return render json: { status: "NO_PULLS" } unless pull
    return render json: { status: "NOT_OPEN_PULL" } unless pull.is_open?
    return render json: { status: "EXIST_REVIEW_REQ" } if pull.review_requests.present?

    pull.review_requests.create do |rr|
      rr.name = pull.name
      rr.room_id = params[:room_id]
      rr.reviewee_id = params[:reviewee_id]
    end

    render json: { status: "OK" }
  end

  def update
    repo = current_user.repos.find_by!(name: params[:repo_name])
    pull = repo.pulls.find_by!(number: params[:pull_num])
    review_req = pull.review_requests.where(room_id: params[:room_id]).first
    review_req.update!(state: :wait_review)
    render json: { status: "OK" }
  end
end
