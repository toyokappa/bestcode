class Users::ProfilesController < ApplicationController
  before_action :set_title

  def show
    @user = User.find_by!(name: params[:name])
    @rooms = @user.owned_rooms.where(is_open: true)
    @rooms = @user.participating_rooms.where(is_open: true) if params[:room_type] == "participating"
  end

  def update_header
    if current_user.update(update_header_params)
      redirect_to users_profile_path(current_user.name), success: "ヘッダー画像を更新しました"
    else
      flash.now[:danger] = "ヘッダー画像の更新に失敗しました"
      render "show"
    end
  end

  def sync_contributions
    current_user.sync_contributions!
    redirect_to users_profile_path(current_user.name), success: "最新のコントリビュート数に更新しました"
  end

  private

    def set_title
      @title = "プロフィール"
    end

    def update_header_params
      params.require(:user).permit(:header_image)
    end
end
