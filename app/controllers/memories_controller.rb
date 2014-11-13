class MemoriesController < ApplicationController
  respond_to :html, :json, :geojson

  def index
    @memories = memories.by_recent
    respond_with @memories
  end

  def show
    @memory = memories.find(params[:id])
    respond_with @memory
  end

  private

  def memories
    Memory.approved
  end
end
