class UserMailer < ActionMailer::Base
  default from: ENV["MAIL_USERNAME"] || 'test@test.com'

  def welcome_on_register(user_id)
    @user = User.find(user_id)
    mail  to: @user.email, subject: "Welcome to Myflix"
  end

  def reset_password(user_id)
    @user = User.find(user_id)
    mail  to: @user.email, subject: "Reset password email"
  end

  def invite_friend(invitation_id)
    @invitation = Invitation.find(invitation_id)
    mail  to: @invitation.friend_email, subject: "Invitation to join MyFlix"
  end
end
