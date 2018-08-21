class Users::TopController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :update

  def index
  end

  def update
    current_user.update!(is_first_time: false)
  end
end
