class Admin::UsersController < Admin::AuthenticatedAdminController
  INDEXES = [:index, :blocked]

  before_action :assign_user, except: INDEXES

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
    toggle_blocked('block')
  end

  def unblock
    toggle_blocked('unblock')
  end

  private

  def assign_user
    @user = User.find(params[:id])
  end

  def toggle_blocked(action)
    message = if @user.send("#{action}!")
      {notice: "User #{@user.screen_name} has been #{action}ed."}
    else
      {alert: "User #{@user.screen_name} could not be #{action}ed."}
    end
    redirect_to admin_user_path(@user), message
  end
end
