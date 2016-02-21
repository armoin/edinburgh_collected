class Admin::Moderation::UsersController < Admin::AuthenticatedAdminController
  INDEXES = [:index, :blocked, :unmoderated, :reported]

  before_action :assign_requested_user, except: INDEXES
  before_action :disallow_if_requested_user_is_current_user, only: :block

  def index
    @items = User.all.order('created_at')
  end

  def unmoderated
    @items = User.unmoderated.order(created_at: :desc)
    render :index
  end

  def blocked
    @items = User.blocked.by_last_moderated
    render :index
  end

  def reported
    @items = User.reported.by_last_reported
    render :index
  end

  def show
  end

  def approve
    moderate_user('approved')
  end

  def unmoderate
    moderate_user('unmoderated')
  end

  def block
    moderate_user('blocked')
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

  def moderate_user(to_state)
    message = if @user.send("#{action_name}!", current_user)
      {notice: "User #{@user.screen_name} has been #{to_state}."}
    else
      {alert: "User #{@user.screen_name} could not be #{to_state}."}
    end
    redirect_to admin_moderation_user_path(@user), message
  end
end

