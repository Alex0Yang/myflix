class UsersController < ApplicationController
  before_action :user_auth, only: :show

  def new
    @user = User.new
  end

  def create
    @user = User.new(_permit_params)

    if @user.save
      UserMailer.welcome_on_register(@user).deliver
      redirect_to sign_in_path, info: 'You are signed in, enjogy!'
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def _permit_params
    params.require(:user).permit(:email, :password, :full_name)
  end

end
