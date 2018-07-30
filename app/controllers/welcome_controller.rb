class WelcomeController < ApplicationController
  skip_before_action :authenticate_user
  layout "authentication"

  def index
  end
end
