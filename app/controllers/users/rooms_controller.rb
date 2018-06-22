class Users::RoomsController < ApplicationController
  before_action :check_reviewable_user, only: [:new, :create]
  before_action :set_room, only: [:edit, :update, :destroy]
  before_action :set_lang_ids, only: [:create, :update]

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])
    @review_assigns = @room.review_assigns
    @review_reqs = current_user.get_visible_review_reqs_from(@review_assigns)
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
    @room.destroy!
    redirect_to users_rooms_path, success: t(".destroy_success", name: @room.name)
  end

  private

    def room_params
      params.require(:room).permit(:name, :description, :capacity)
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
      redirect_to users_rooms_path, danger: t(".unreviewable_error") unless current_user.is_reviewer?
    end
end
