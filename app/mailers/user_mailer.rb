class UserMailer < ActionMailer::Base
  def welcome_on_register(user_id)
    @user = User.find(user_id)
    mail from: ENV["MAIL_USERNAME"], to: @user.email, subject: "Welcome to Myflix"
  end

  def reset_password(user_id)
    @user = User.find(user_id)
    mail from: ENV["MAIL_USERNAME"], to: @user.email, subject: "Reset password email"
  end

  def invite_friend(invitation_id)
    @invitation = Invitation.find(invitation_id)
    mail from: ENV["MAIL_USERNAME"], to: @invitation.friend_email, subject: "Invitation to join MyFlix"
  end
end
