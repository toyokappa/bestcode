class Users::TopController < ApplicationController
  def index
  end

  def update
    current_user.update!(is_first_time: false)
  end
end
