class MemoriesController < ApplicationController
  respond_to :html, :json, :geojson

  def index
    @memories = Memory.approved.by_recent
    respond_with @memories
  end

  def show
    @memory = Memory.find(params[:id])
    respond_with @memory
  end
end
