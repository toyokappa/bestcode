class RoomsController < ApplicationController
  before_action :check_reviewable_user, only: [:new, :create]
  before_action :set_room, only: [:edit, :update, :destroy]

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])
  end

  def new
    @room = current_user.owned_rooms.build
  end

  def create
    @room = current_user.owned_rooms.build(room_params)
    if @room.save
      redirect_to @room, success: "ルームを作成しました"
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @room.update(room_params)
      redirect_to @room, success: "ルームを更新しました"
    else
      render "edit"
    end
  end

  def destroy
    @room.destroy!
    redirect_to rooms_path, success: "ルームを削除しました"
  end

  private

    def room_params
      params.require(:room).permit(:name, :description, :capacity)
    end

    def set_room
      @room = current_user.owned_rooms.find(params[:id])
    end

    def check_reviewable_user
      redirect_to rooms_path, danger: "ルームを作成する権限がありません" unless current_user.is_reviewer?
    end
end
