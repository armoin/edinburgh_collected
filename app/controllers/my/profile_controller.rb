class My::ProfileController < My::AuthenticatedUserController
  include UpdateWithImage

  before_action :assign_current_user

  def show
  end

  def edit
    build_form_data
  end

  def update
    if update_and_process_image(@user, user_params)
      redirect_to my_profile_path, notice: 'Successfully changed your details.'
    else
      build_form_data
      render :edit
    end
  end

  def destroy
    current_user.mark_deleted!(current_user)
    redirect_to :root, notice: 'Your account has now been deleted.'
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

