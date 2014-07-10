class AssetsController < ApplicationController
  def index
    @assets = Asset.all
  end

  def show
    @asset = Asset.find(params[:id])
  rescue Exception => e
    render 'assets/not_found'
  end

  def new
    @asset = Asset.new
  end

  def create
    Asset.create(params[:asset])
    redirect_to assets_url
  end
end
