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
    @invite_token = params[:invite_token]

    if @user.valid?
      handle_charge and return
      @user.save
      handle_invitation
      UserMailer.delay.welcome_on_register(@user.id)
      flash[:notice] = 'Thank you for registering with MyFLix. Please sign in now.'
      redirect_to sign_in_path
    else
      flash[:danger] = "Invalid user inforamtion, Please check the errors below."
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

  def handle_invitation
    invitation = Invitation.find_by(invite_token: @invite_token)
    if invitation
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:invite_token, nil)
    end
  end

  def handle_charge
    amount = 99

    charge = StripeWrapper::Charge.create(
      :source  => params[:stripeToken],
      :amount      => amount,
      :description => "Sign up change for #{@user.email}",
    )

    unless charge.successful?
      flash[:error] = charge.error_message
      render :new and return true
    end
  end
end

