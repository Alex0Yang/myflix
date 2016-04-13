class InvitationsController < ApplicationController
  before_action :user_auth

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = current_user.invitations.build invitation_params

    if @invitation.save
      UserMailer.invite_friend(@invitation).deliver
      flash[:info] = "You have successfully invited #{@invitation.friend_name}."
      redirect_to new_invitation_path
    else
      flash.now[:danger] = "Please check your input."
      render 'new'
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:friend_name, :friend_email, :message)
  end
end
