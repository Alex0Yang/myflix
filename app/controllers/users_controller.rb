class UsersController < ApplicationController
  before_action :user_auth, only: :show

  def new
    @user = User.new
  end

  def new_with_invitation_token
    @user = User.new
    invitation = Invitation.find_by(invite_token: params[:invite_token])

    if invitation
      @invite_token = params[:invite_token]
      @user.email = invitation.friend_email
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def create
    @user = User.new(_permit_params)

    result = UserCreation.new(@user).signup(invite_token: params[:invite_token], stripe_token: params[:stripeToken])
    if result.successful?
      flash[:notice] = 'Thank you for registering with MyFLix. Please sign in now.'
      redirect_to sign_in_path
    else
      flash[:danger] = result.error_message
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

