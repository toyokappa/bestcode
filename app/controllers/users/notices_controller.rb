class Users::NoticesController < ApplicationController
  def create
    reciever = User.find(params[:reciever_id])
    return render json: { status: "NOT NOTICE" } if reciever.is_noticed_in_30_minutes?

    UnreadMailer.notice(current_user, reciever, params[:chat_url]).deliver_later!
    reciever.update!(noticed_at: Time.zone.now)
    render json: { status: "SUCCESS NOTICE" }
  end
end
