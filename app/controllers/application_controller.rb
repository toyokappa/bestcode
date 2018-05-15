class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?
  before_action :authenticate_user

  private
    
    def authenticate_user
      redirect_to root_path, alert: t(:authentication_alert, scope: :flash) unless user_signed_in?
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def user_signed_in?
      current_user.present?
    end
end
