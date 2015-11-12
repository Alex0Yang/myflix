class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :sign_in?, :sign_in_user

  def sign_in?
    !session[:user_id].nil?
  end

  def sign_in_user
    if sign_in?
      @user ||= User.find(session[:user_id])
    end
  end

  def user_auth
    unless sign_in?
      flash[:info] = "Access reserved for members only. Please sign in first."
      redirect_to sign_in_path
    end
  end
end
