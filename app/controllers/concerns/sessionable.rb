module Sessionable
  extend ActiveSupport::Concern

  private

    def authenticate_user
      unless user_signed_in?
        store_location
        redirect_to root_path, danger: t(:alert_authentication, scope: :flash)
      end
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def user_signed_in?
      current_user.present?
    end

    def store_location
      session[:forwarding_url] = request.original_url if request.get?
    end

    def redirect_back_or(default)
      redirect_to(session[:forwarding_url] || default)
      session.delete(:forwarding_url)
    end
end
