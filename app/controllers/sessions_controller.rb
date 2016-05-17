class SessionsController < ApplicationController
  def front
    redirect_to videos_path if current_user
  end

  def new
    redirect_to videos_path if current_user
  end

  def create
    user = User.find_by email: params[:email]

    if user && user.authenticate(params[:password])
      if user.payment_failure?
        flash[:danger] = "payment failure"
        render :new
      else
        session[:user_id] = user.id
        flash[:success] = "You are signed in, enjoy!"
        redirect_to videos_path
      end
    else
      flash.now[:danger] = "Incorrect email or password, Please try again"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You are signed out, bye!"
    redirect_to sign_in_path
  end
end
