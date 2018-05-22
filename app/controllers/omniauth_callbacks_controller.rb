class OmniauthCallbacksController < ApplicationController
  skip_before_action :authenticate_user, only: [:callback]

  def callback
    auth = request.env["omniauth.auth"]
    user = User.find_by(provider: auth.provider, uid: auth.uid) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_path, success: t(:success_sign_in, scope: :flash)
  end
end
