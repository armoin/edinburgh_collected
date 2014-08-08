class Workspace::AssetsController < Workspace::AuthenticatedUserController
  def index
    @assets = Asset.user(current_user)
  end

  def new
    @asset = Asset.new
  end

  def create
    @asset = Asset.new(params[:asset])
    if @asset.save(current_user)
      redirect_to workspace_assets_url
    else
      render :new
    end
  end
end

