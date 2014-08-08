class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_back_or_to :root, notice: 'Successfully signed in'
    else
      flash[:alert] = 'Could not sign in'
      render :new
    end
  end

  def destroy
    logout
    redirect_to :root, notice: 'Signed out'
  end
end

