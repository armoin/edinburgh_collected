class My::ProfileController < My::AuthenticatedUserController
  before_action :assign_current_user

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to my_profile_path, notice: 'Successfully changed your details.'
    else
      render :edit
    end
  end

  private

  def assign_current_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :screen_name,
      :is_group,
      :email,
      :password,
      :password_confirmation
    )
  end
end

