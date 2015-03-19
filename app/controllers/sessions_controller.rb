class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = login(params[:email], params[:password])

    redirect_to :signin, alert: 'Email or password was incorrect.' and return unless @user

    if @user.is_blocked?
      logout
      redirect_to :signin, alert: 'Your account has been blocked. Please contact an administrator if you would like to have it unblocked.'
    else
      redirect_back_or_to default_land_page, notice: 'Successfully signed in'
    end
  end

  def destroy
    logout
    redirect_to :root, notice: 'Signed out'
  end

  private

  def default_land_page
    @user.try(:is_admin?) ? admin_home_path : my_memories_path
  end
end
