class PasswordsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:email]
    if user
      user.update_attribute(:reset_token, SecureRandom.urlsafe_base64)
      UserMailer.reset_password(user).deliver
      flash[:info] = "reset password email has sent to your email inbox"
      redirect_to root_path
    else
      flash.now[:danger] = "email is not existed, plese check"
      render :new
    end
  end

  def update
    user = User.find_by reset_token: password_reset_params[:reset_token]
    if user
      user.update_attributes(password: password_reset_params[:password], reset_token: nil)
      redirect_to sign_in_path
    else
      redirect_to forgot_password_path
    end
  end

  def show
    user = User.find_by reset_token: params[:reset_token]
    @reset_token = params[:reset_token]
    unless user
      flash[:danger] = "reset link is invalid"
      redirect_to forgot_password_path
      return
    end
  end

  private

  def password_reset_params
    params.require(:user).permit(:reset_token, :password)
  end
end
