class User::AssetsController < User::AuthenticatedUserController
  def index
    @assets = Asset.user(session[:auth_token])
  end

  def new
    @asset = Asset.new
  end

  def create
    @asset = Asset.new(params[:asset])
    if @asset.save(session[:auth_token])
      redirect_to user_assets_url
    else
      render :new
    end
  end
end

