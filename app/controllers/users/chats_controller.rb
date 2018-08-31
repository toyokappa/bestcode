class Users::ChatsController < ApplicationController
  layout "chat"

  def index
    @title = "チャット"
    @room = Room.find(params[:room_id])
    return if params[:reviewee_id].blank?

    reviewee = @room.reviewees.find_by(id: params[:reviewee_id])
    return flash.now[:danger] = "不正なチャットルームです" unless reviewee

    gon.auth_token = current_user.firebase_auth_token
    gon.room_chat_id = @room.chat_id(params[:reviewee_id])
    gon.current_user = { id: current_user.chat_id }
    gon.users_info = {
      reviewer: {
        id: @room.reviewer.chat_id,
        image: @room.reviewer.image.url,
        profile_path: users_profile_path(@room.reviewer.name)
      },
      reviewee: {
        id: reviewee.chat_id,
        image: reviewee.image.url,
        profile_path: users_profile_path(reviewee.name)
      }
    }
  end
end
