class AuthenticationMailer < ActionMailer::Base
  default from: CONTACT_EMAIL

  def reset_password_email(user)
    @user = user
    @url  = edit_password_reset_url(user.reset_password_token)

    mail to: user.email
  end

  def activation_needed_email(user)
    @user = user
    @url  = activate_user_url(user.activation_token)

    mail to: user.email
  end

  def activation_success_email(user)
    @user = user
    @url  = signin_url

    mail to: user.email, subject: t('.subject', app_name: APP_NAME)
  end
end
