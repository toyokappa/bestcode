class StaticController < ApplicationController
  skip_before_action :authenticate_user
  layout "authentication"

  def terms
  end

  def privacy_policy
  end
end
