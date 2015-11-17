class SessionsController < ApplicationController
  def front
    redirect_to videos_path if current_user
  end

  def new
    redirect_to videos_path if current_user
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to videos_path
    else
      flash.now[:danger] = "Incorrect email or password, Please try again"
      render :new
    end
  end

  def destroy
    if params[:user] == session[:user_id].to_s
      session[:user_id] = nil
    end

    redirect_to sign_in_path
  end
end
