class UsersController < ApplicationController
  def new
    @user = User.new
    build_form_data
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to :root, notice: 'Please click the link in the activation email we have just sent in order to continue.'
    else
      build_form_data
      render :new
    end
  end

  def activate
    if @user = User.load_from_activation_token(params[:id])
      @user.activate!
      redirect_to :signin, :notice => 'You have successfully activated your account. Please sign in.'
    else
      not_authenticated
    end
  end

  def resend_activation_email
    if current_user && current_user.pending?
      AuthenticationMailer.activation_needed_email(current_user).deliver
      message = { notice: 'We have resent your activation email. Please check you spam filter if it has still not appeared within the next hour.' }
    else
      message = { alert: 'It does not look like you need to be activated.' }
    end
    redirect_to :root, message
  end

  private

  def user_params
    UserParamCleaner.clean(params)
  end

  def build_form_data
    @user.links.build
    @temp_image = TempImage.new
  end
end

