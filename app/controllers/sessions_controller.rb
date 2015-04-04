class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_back_or_to landing_page_for(@user), notice: 'Successfully signed in'
    else
      redirect_to :signin, alert: 'Email or password was incorrect.'
    end
  end

  def destroy
    logout
    redirect_to :root, notice: 'Signed out'
  end
end
