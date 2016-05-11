class UserCreation
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def signup(options)
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        :source  => options[:stripe_token],
        :amount      => 99,
        :description => "Sign up change for #{@user.email}",
      )
      if charge.successful?
        @user.save
        handle_invitation(options[:invite_token])
        UserMailer.delay.welcome_on_register(@user.id)
        @status = :success
      else
        @status = :failed
        @error_message = charge.error_message
      end
      self
    else
      @status = :failed
      @error_message = "Invalid user inforamtion, Please check the errors below."
      self
    end
  end

  def successful?
   @status == :success
  end

  private

  def handle_invitation(invite_token)
    invitation = Invitation.find_by(invite_token: invite_token)
    if invitation
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:invite_token, nil)
    end
  end
end
