class MemoriesController < ApplicationController
  before_action :store_memory_index_path, only: :index

  respond_to :html, :json, :geojson

  def index
    @memories = memories.by_recent.page(params[:page])
    respond_with @memories
  end

  def show
    @memory = Memory.find(params[:id])
    raise ActiveRecord::RecordNotFound unless viewable?(@memory)
    respond_with @memory
  end

  private

  def memories
    Memory.publicly_visible
  end

  def viewable?(memory)
    memory.publicly_visible? ||
      current_user.try(:can_modify?, memory)
  end
end
