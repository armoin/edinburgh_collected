class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    authenticator = Authenticator.new(params[:email], params[:password])

    if authenticator.user_authenticated?
      @user = login(params[:email], params[:password])
      redirect_back_or_to default_land_page, notice: 'Successfully signed in'
    else
      redirect_to :signin, alert: authenticator.error_message
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
