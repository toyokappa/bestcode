class Users::ChatsController < ApplicationController
  layout "chat"
  before_action :check_room_reviewee

  def index
    @title = "チャット"
    gon.auth_token = current_user.firebase_auth_token
    gon.room_chat_ids = @room.reviewees.map {|reviewee| @room.chat_id(reviewee.id) }
    gon.current_user = { 
      id: current_user.chat_id,
      name: current_user.name
    }
    return if params[:reviewee_id].blank?

    @reviewee = @room.reviewees.find_by(id: params[:reviewee_id])
    @reviewer = @room.reviewer
    return flash.now[:danger] = "不正なチャットルームです" unless @reviewee

    gon.room_chat_id = @room.chat_id(params[:reviewee_id])
    gon.users_info = {
      reviewer: {
        id: @reviewer.chat_id,
        image: @reviewer.image.url,
        profile_path: users_profile_path(@reviewer.name)
      },
      reviewee: {
        id: @reviewee.chat_id,
        image: @reviewee.image.url,
        profile_path: users_profile_path(@reviewee.name)
      }
    }
  end

  private

    def check_room_reviewee
      @room = Room.find(params[:room_id])
      unless current_user.participating?(@room) || current_user.own?(@room)
        redirect_to users_room_path(@room), danger: "ルームに参加してください" 
      end
    end
end
