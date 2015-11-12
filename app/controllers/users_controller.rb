class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(_permit_params)

    if @user.save
      redirect_to videos_path
    else
      render :new
    end
  end

  private

  def _permit_params
    params.require(:user).permit(:email, :password, :full_name)
  end

end
