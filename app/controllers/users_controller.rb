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
    invitation = Invitation.find_by(invite_token: @invite_token)

    if @user.valid? && charge_user
      @user.save
      if invitation
        @user.follow(invitation.inviter)
        invitation.inviter.follow(@user)
        invitation.update_column(:invite_token, nil)
      end
      UserMailer.delay.welcome_on_register(@user.id)
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

  def charge_user
    amount = 999

    begin
      charge = Stripe::Charge.create(
        :source  => params[:stripeToken],
        :amount      => amount,
        :description => "Sign up change for #{@user.email}",
        :currency    => 'usd'
      )

    rescue Stripe::CardError => e
      flash[:error] = e.message
      return
    end
  end

end
