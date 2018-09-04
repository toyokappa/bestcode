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
    pull = current_user.pulls.where(is_open: true).find_by(url: params[:url])
    return render json: { status: "NO_PULLS" } unless pull
    return render json: { status: "EXIST_REVIEW_REQ" } if pull.review_requests.present?

    pull.review_requests.create do |rr|
      rr.name = pull.name
      rr.room_id = params[:room_id]
      rr.reviewee_id = params[:reviewee_id]
    end

    render json: { status: "OK" }
  end
end
