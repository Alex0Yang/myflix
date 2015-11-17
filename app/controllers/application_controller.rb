class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    if session[:user_id]
      @user ||= User.find(session[:user_id])
    end
  end

  def user_auth
    unless current_user
      flash[:info] = "Access reserved for members only. Please sign in first."
      redirect_to sign_in_path
    end
  end
end
