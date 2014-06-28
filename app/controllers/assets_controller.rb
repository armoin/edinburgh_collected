class AssetsController < ApplicationController
  def index
    @assets = Asset.all
  end

  def new
  end

  def create
    Asset.create(params[:asset])
    redirect_to assets_url
  end
end
