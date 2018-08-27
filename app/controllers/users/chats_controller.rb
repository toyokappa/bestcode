class Users::ChatsController < ApplicationController
  layout "chat"

  def index
    @title = "チャット"
    @room = Room.find(params[:room_id])
  end
end
