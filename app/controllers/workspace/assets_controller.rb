class Workspace::AssetsController < Workspace::AuthenticatedUserController
  def index
    @assets = current_user.assets
  end

  def new
    @asset = Asset.new
  end

  def create
    @asset = Asset.new(asset_params)
    @asset.user = current_user
    if @asset.save
      redirect_to workspace_assets_url
    else
      render :new
    end
  end

  private

  def asset_params
    params.require(:asset).permit(
      :title,
      :file_type,
      :source,
      :description,
      :year,
      :month,
      :day,
      :width,
      :height,
      :resolution,
      :device,
      :length,
      :is_readable,
      :attribution,
      :area_id,
      :location
    )
  end
end

