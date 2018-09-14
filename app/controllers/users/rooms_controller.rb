class Users::RoomsController < ApplicationController
  before_action :set_title
  before_action :check_reviewable_user, only: [:new, :create]
  before_action :check_evaluatable, only: [:show]
  before_action :set_room, only: [:edit, :update, :destroy, :reopen]
  before_action :set_lang_ids, only: [:create, :update]

  def index
    @title = "ルーム一覧"
    @rooms = Room.where(is_open: true).order(created_at: :desc)
  end

  def show
    @title = "ルーム詳細"
  end

  def new
    @room = current_user.owned_rooms.build
  end

  def create
    @room = current_user.owned_rooms.build(room_params)
    if @room.save && @room.change_skills_by(@lang_ids)
      redirect_to users_room_path(@room), success: t(".create_success", name: @room.name)
    else
      render "new"
    end
  end

  def edit
    @lang_ids = @room.language_ids
  end

  def update
    if @room.update(room_params) && @room.change_skills_by(@lang_ids)
      redirect_to users_room_path(@room), success: t(".update_success", name: @room.name)
    else
      render "edit"
    end
  end

  def destroy
    @room.close!
    redirect_to users_room_path(@room), success: t(".close_success", name: @room.name)
  end

  def reopen
    @room.open!
    redirect_to users_room_path(@room), success: t(".reopen_success", name: @room.name)
  end

  private

    def set_title
      @title = "ルーム"
    end

    def room_params
      params.require(:room).permit(:name, :description, :capacity, :image)
    end

    def skill_params
      params.require(:skill).permit(language: [])
    end

    def set_room
      @room = current_user.owned_rooms.find(params[:id])
    end

    def set_lang_ids
      @lang_ids = skill_params["language"].reject(&:blank?)
    end

    def check_reviewable_user
      redirect_to users_rooms_path, danger: t(".unreviewable_error") unless current_user.reviewer?
    end

    def check_evaluatable
      @room = Room.find(params[:id])
      return unless current_user.participating?(@room)
      return if current_user.evaluated?(@room)

      participated_at = current_user.participations.find_by(participating_room: @room).created_at
      participating_term = (Time.zone.now.to_date - participated_at.to_date).to_i
      return if participating_term < 30

      redirect_to new_users_rooms_evaluation_path(@room), success: "#{@room.name}の評価をしてください"
    end
end
