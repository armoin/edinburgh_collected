class User::AssetsController < User::AuthenticatedUserController
  def index
    @assets = Asset.user(session[:auth_token])
  end
end

