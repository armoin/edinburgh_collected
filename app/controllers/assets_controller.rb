class AssetsController < ApplicationController
  def index
    @assets = Asset.all
  end

  def show
    @asset = Asset.find(params[:id])
  rescue Exception => e
    render 'assets/not_found'
  end
end
