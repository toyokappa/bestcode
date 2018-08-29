class Users::ChatsController < ApplicationController
  layout "chat"

  def index
    @title = "チャット"
    @room = Room.find(params[:room_id])
    if params[:reviewee_id].present?
      reviewee = @room.reviewees.find(params[:reviewee_id])
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
end
