class Authenticator
  def initialize(email, password)
    @user = User.authenticate(email, password)
  end

  def user_authenticated?
    @user.present? && !@user.is_blocked?
  end

  def error_message
    if @user.try(:is_blocked?)
      'Your account has been blocked. Please contact us if you would like more information.'
    else
      'Email or password was incorrect.'
    end
  end
end
