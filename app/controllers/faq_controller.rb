class FaqController < ApplicationController
  skip_before_action :authenticate_user
  layout "authentication"
end
