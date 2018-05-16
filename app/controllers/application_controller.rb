class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?
  before_action :authenticate_user
  add_flash_types :success, :danger

  private
    
    def authenticate_user
      redirect_to root_path, danger: t(:alert_authentication, scope: :flash) unless user_signed_in?
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def user_signed_in?
      current_user.present?
    end
end
