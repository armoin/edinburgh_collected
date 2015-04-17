class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_reset_password_instructions!
      redirect_to root_path, notice: 'Instructions have been sent to your email.'
    else
      flash.now[:alert] = "Sorry but we don't recognise the email address \"#{params[:email]}\"."
      render :new
    end
  end

  def edit
    @user = User.load_from_reset_password_token(params[:id])
    @token = params[:id]

    if @user.blank?
      not_authenticated
      return
    end
  end

  def update
    @user = User.load_from_reset_password_token(params[:id])
    @token = params[:id]

    if @user.blank?
      not_authenticated
      return
    end

    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password!(params[:user][:password])
      redirect_to signin_path, notice: 'Password was successfully updated.'
    else
      render :edit
    end
  end
end

