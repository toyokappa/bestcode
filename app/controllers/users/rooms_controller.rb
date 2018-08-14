class Users::RoomsController < ApplicationController
  before_action :check_reviewable_user, only: [:new, :create]
  before_action :set_room, only: [:edit, :update, :destroy, :reopen]
  before_action :set_lang_ids, only: [:create, :update]

  def index
    @rooms = Room.where(is_open: true).order(created_at: :desc)
  end

  def show
    @room = Room.find(params[:id])
    if check_evaluation
      return redirect_to new_users_rooms_evaluation_path(@room), success: "#{@room.name}の評価をしてください"
    end

    @review_assigns = get_review_reqs_with(params[:open_state])

    # get_visible_review_reqs_fromの戻り値がArrayとなるためorderではなくsort_byで順序を変更
    @review_reqs = current_user.get_visible_review_reqs_from(@review_assigns).sort_by(&:created_at).reverse
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
      redirect_to users_rooms_path, danger: t(".unreviewable_error") unless current_user.is_reviewer?
    end

    def check_evaluation
      return unless current_user.participating?(@room)

      participated_at = current_user.participations.find_by(participating_room: @room).created_at
      participating_term = (Time.zone.now.to_date - participated_at.to_date).to_i

      participating_term >= 30 && !current_user.evaluated?(@room)
    end

    def get_review_reqs_with(open_state)
      case open_state
      when "closed"
        @room.review_assigns.where(is_open: false).order(created_at: :desc)
      when "all"
        @room.review_assigns.order(created_at: :desc)
      else
        @room.review_assigns.where(is_open: true).order(created_at: :desc)
      end
    end
end
