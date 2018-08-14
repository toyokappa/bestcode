class WelcomeController < ApplicationController
  skip_before_action :authenticate_user
  before_action :check_sign_in
  layout "authentication"

  def index
  end

  private

    def check_sign_in
      redirect_to users_root_path if user_signed_in?
    end
end
