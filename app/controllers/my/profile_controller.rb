class My::ProfileController < My::AuthenticatedUserController
  def show
    @user = current_user
  end
end

