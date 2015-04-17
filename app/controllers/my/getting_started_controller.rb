class My::GettingStartedController < My::AuthenticatedUserController
  def index
  end

  def skip_getting_started
    if current_user.update(user_params)
      redirect_to my_memories_path, notice: success_message
    else
      redirect_to my_memories_path
    end
  end

  private

  def user_params
    UserParamCleaner.clean(params)
  end

  def success_message
    message = ""
    if current_user.hide_getting_started?
      message << "Got it. We'll not show you the Getting Started page when you log in. "
    end
    message << "You can access the Getting Started page from the My account menu at any time."
  end
end