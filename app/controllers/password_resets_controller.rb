class PasswordResetsController < ApplicationController
  def show
    user = User.find_by reset_token: params[:reset_token]
    @reset_token = params[:reset_token]
    unless user
      redirect_to  expired_token_path
      return
    end
  end

  def create
    user = User.find_by reset_token: password_reset_params[:reset_token]
    if user
      user.update_attributes(password: password_reset_params[:password], reset_token: nil)
      flash[:success] = "update password successfully!"
      redirect_to sign_in_path
    else
      redirect_to expired_token_path
    end
  end

  def expired_token
  end

  private

  def password_reset_params
    params.require(:user).permit(:reset_token, :password)
  end
end
