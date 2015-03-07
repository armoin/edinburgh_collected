class My::ProfileController < My::AuthenticatedUserController
  before_action :assign_current_user

  def show
  end

  def edit
    build_form_data
  end

  def update
    if @user.update(user_params) && @user.process_image
      redirect_to my_profile_path, notice: 'Successfully changed your details.'
    else
      build_form_data
      render :edit
    end
  end

  private

  def assign_current_user
    @user = current_user
  end

  def build_form_data
    @user.links.build unless @user.links.any?
    @temp_image = TempImage.new
  end

  def user_params
    UserParamCleaner.clean(params)
  end
end

