class Users::ProfilesController < ApplicationController
  def show
    @user = User.find_by!(name: params[:name])
    @rooms = @user.owned_rooms.where(is_open: true)
    @rooms = @user.participating_rooms.where(is_open: true) if params[:room_type] == "participating"
  end

  def update_header
    @user = User.find_by!(name: params[:name])
    if @user.update(update_header_params)
      redirect_to users_profile_path(@user.name), success: "ヘッダー画像を更新しました"
    else
      flash.now[:danger] = "ヘッダー画像の更新に失敗しました"
      render "show"
    end
  end

  private

    def update_header_params
      params.require(:user).permit(:header_image)
    end
end
