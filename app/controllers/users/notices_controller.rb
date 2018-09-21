class Users::NoticesController < ApplicationController
  def create
    receiver = User.find(params[:receiver_id])
    return render json: { status: "NOT NOTICE" } if receiver.is_noticed_in_30_minutes?

    UnreadMailer.notice(current_user, receiver, params[:chat_url]).deliver_later!
    receiver.update!(noticed_at: Time.zone.now)
    render json: { status: "SUCCESS NOTICE" }
  end
end
