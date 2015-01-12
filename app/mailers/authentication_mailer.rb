class AuthenticationMailer < ActionMailer::Base
  default from: ENV['CONTACT_EMAIL']

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.authentication_mailer.reset_password_email.subject
  #
  def reset_password_email(user)
    @user = user
    @url  = edit_password_reset_url(user.reset_password_token)
    mail(to: user.email, subject: "Reset password")
  end

  def activation_needed_email(user)
    @user = user
    @url  = activate_user_url(user.activation_token)

    mail to: user.email,
         subject: 'Please activate your account'
  end

  def activation_success_email(user)
    @user = user
    @url  = signin_url

    mail to: user.email
  end
end
