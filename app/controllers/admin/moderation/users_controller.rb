class Admin::Moderation::UsersController < Admin::AuthenticatedAdminController
  INDEXES = [:index, :blocked, :unmoderated, :reported]

  before_action :assign_requested_user, except: INDEXES
  before_action :disallow_if_requested_user_is_current_user, only: [:block, :unblock]

  def index
    @items = User.all.order('created_at')
  end

  def unmoderated
    @items = User.unmoderated.order('created_at')
    render :index
  end

  def blocked
    @items = User.blocked.by_last_moderated
    render :index
  end

  def reported
    @items = User.reported.by_first_moderated
    render :index
  end

  def show
  end

  def approve
    message = if @user.approve!(current_user)
      {notice: "User #{@user.screen_name} has been approved."}
    else
      {alert: "User #{@user.screen_name} could not be approved."}
    end
    redirect_to admin_moderation_user_path(@user), message
  end

  def unmoderate
    message = if @user.unmoderate!(current_user)
      {notice: "User #{@user.screen_name} has been unmoderated."}
    else
      {alert: "User #{@user.screen_name} could not be unmoderated."}
    end
    redirect_to admin_moderation_user_path(@user), message
  end

  def block
    toggle_blocked
  end

  def unblock
    toggle_blocked
  end

  private

  def assign_requested_user
    @user ||= User.find(params[:id])
  end

  def disallow_if_requested_user_is_current_user
    if @user == current_user
      redirect_to admin_moderation_user_path(@user), alert: "You can't #{action_name} your own account." and return
    end
  end

  def toggle_blocked
    message = if @user.send("#{action_name}!")
      {notice: "User #{@user.screen_name} has been #{action_name}ed."}
    else
      {alert: "User #{@user.screen_name} could not be #{action_name}ed."}
    end
    redirect_to admin_moderation_user_path(@user), message
  end
end

