class OmniauthCallbacksController < ApplicationController
  skip_before_action :authenticate_user, only: [:callback]

  def callback
    auth = request.env["omniauth.auth"]
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    flash[:success] = t(:success_sign_in, scope: :flash)

    if user
      user.update!(access_token: auth.credentials.token)
    else
      user = User.create_with_omniauth(auth)
      flash[:success] = t(:success_sign_up, scope: :flash)
    end

    session[:user_id] = user.id
    cookies.permanent[:signup_agreement] = true
    redirect_back_or users_root_path
  end
end
