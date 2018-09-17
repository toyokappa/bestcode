class ApplicationController < ActionController::Base
  include Sessionable
  helper_method :current_user, :user_signed_in?
  before_action :authenticate_user
  add_flash_types :success, :danger
end
