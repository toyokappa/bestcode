class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?

  private
    
    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def user_signed_in?
      current_user.present?
    end
end
