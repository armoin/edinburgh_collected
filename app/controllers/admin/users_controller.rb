class Admin::UsersController < Admin::AuthenticatedAdminController
  before_action :assign_user

  def show
  end

  def block
    message = if @user.block!
      {notice: "User #{@user.screen_name} has been blocked."}
    else
      {alert: "User #{@user.screen_name} could not be blocked."}
    end
    redirect_to admin_user_path(@user), message
  end

  private

  def assign_user
    @user = User.find(params[:id])
  end
end
