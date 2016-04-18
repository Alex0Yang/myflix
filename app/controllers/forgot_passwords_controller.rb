class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by email: params[:email]
    if user
      user.update_column(:reset_token, SecureRandom.urlsafe_base64)
      UserMailer.delay.reset_password(user.id)
      redirect_to forgot_password_confirmation_path
    else
      flash[:danger] = params[:email].blank? ? "Email cannot be blank." : "User is not existed."
      redirect_to forgot_password_path
    end
  end
end
