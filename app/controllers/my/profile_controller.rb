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
    case
      when user_params[:account_will_be_deleted] != 'understood'
        flash[:alert] = "We couldn't delete your account because you didn't click the understood box"
        render :show and return
      when current_user.featured?

        alert_message = %Q[
          Sorry, but one of your memories or scrapbooks is currently featured
          on the #{APP_NAME} home page.
          <br />
          <br />
          Please contact us at
          #{view_context.mail_to(CONTACT_EMAIL)}
          to delete your account.
        ]
        flash[:alert] = alert_message.html_safe
        render :show and return
      else
        current_user.mark_deleted!(current_user)
        redirect_to :root, notice: 'Your account has now been deleted.'
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

