class Users::SessionsController < ApplicationController
  def destroy
    session.delete(:user_id)
    redirect_to root_path, success: t(:success_sign_out, scope: :flash)
  end
end
