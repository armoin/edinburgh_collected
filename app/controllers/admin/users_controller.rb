class Admin::UsersController < Admin::AuthenticatedAdminController
  INDEXES = [:index, :blocked]

  before_action :assign_user, except: INDEXES
  before_action :disallow_if_requested_user_is_current_user, only: [:block, :unblock]

  def index
    @users = User.all.order('screen_name')
  end

  def blocked
    @users = User.blocked.order('screen_name')
    render :index
  end

  def show
  end

  def block
    toggle_blocked
  end

  def unblock
    toggle_blocked
  end

  private

  def assign_user
    @user = User.find(params[:id])
  end

  def disallow_if_requested_user_is_current_user
    if @user == current_user
      redirect_to admin_user_path(@user), alert: "You can't #{action_name} your own account." and return
    end
  end

  def toggle_blocked
    message = if @user.send("#{action_name}!")
      {notice: "User #{@user.screen_name} has been #{action_name}ed."}
    else
      {alert: "User #{@user.screen_name} could not be #{action_name}ed."}
    end
    redirect_to admin_user_path(@user), message
  end
end
