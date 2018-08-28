class Users::ChatsController < ApplicationController
  layout "chat"

  def index
    @title = "チャット"
    @room = Room.find(params[:room_id])
    gon.room_chat_id = @room.chat_id(params[:reviewee_id]) if params[:reviewee_id].present?
  end
end
