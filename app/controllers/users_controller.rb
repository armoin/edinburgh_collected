class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to :root, notice: 'Please click the link in the activation email we have just sent in order to continue.'
    else
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

  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :screen_name,
      :is_group,
      :email,
      :password,
      :password_confirmation,
      :accepted_t_and_c
    )
  end
end

