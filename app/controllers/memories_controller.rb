class MemoriesController < ApplicationController
  respond_to :html, :json, :geojson

  def index
    @memories = Memory.all
    respond_with @memories
  end

  def show
    @memory = Memory.find(params[:id])
    respond_with @memory
  end
end
