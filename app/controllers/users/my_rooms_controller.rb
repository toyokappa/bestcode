class Users::MyRoomsController < ApplicationController
  before_action :check_user_role, only: :reviewer
  before_action :set_title

  def reviewer
    @open_state = params[:open_state].presence || "open"
    @rooms =
      case @open_state
      when "closed"
        current_user.owned_rooms.where(is_open: false)
      when "all"
        current_user.owned_rooms
      else
        current_user.owned_rooms.where(is_open: true)
      end
  end

  def reviewee
    @open_state = params[:open_state].presence || "open"
    @rooms =
      case @open_state
      when "closed"
        current_user.participating_rooms.where(is_open: false)
      when "all"
        current_user.participating_rooms
      else
        current_user.participating_rooms.where(is_open: true)
      end
  end

  private

    def check_user_role
      redirect_to users_root_path, danger: "ページの閲覧権限がありません" unless current_user.reviewer?
    end

    def set_title
      @title = "ルーム管理"
    end
end
