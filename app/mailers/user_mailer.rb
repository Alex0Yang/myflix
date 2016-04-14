class UserMailer < ActionMailer::Base
  def welcome_on_register(user)
    @user = user
    mail from: ENV["MAIL_USERNAME"], to: user.email, subject: "Welcome to Myflix"
  end

  def reset_password(user)
    @user = user
    mail from: ENV["MAIL_USERNAME"], to: user.email, subject: "Reset password email"
  end

  def invite_friend(invitation)
   @invitation = invitation
   mail from: ENV["MAIL_USERNAME"], to: @invitation.friend_email, subject: "Invitation to join MyFlix"
  end
end
