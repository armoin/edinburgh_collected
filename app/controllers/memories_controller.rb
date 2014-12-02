class MemoriesController < ApplicationController
  respond_to :html, :json, :geojson

  def index
    @memories = memories.by_recent.page(params[:page]).per(30)
    respond_with @memories
  end

  def show
    @memory = Memory.find(params[:id])
    raise ActiveRecord::RecordNotFound unless viewable?(@memory)
    respond_with @memory
  end

  private

  def memories
    Memory.approved
  end

  def viewable?(memory)
    memory.approved? ||
      current_user.try(:can_modify?, memory)
  end
end
