class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: "User", foreign_key: "user_id"
  validates_presence_of :friend_email, :friend_name, :message

  before_create :generate_invite_token

  def generate_invite_token
    self.invite_token = SecureRandom.urlsafe_base64
  end
end
