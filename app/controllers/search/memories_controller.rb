class Search::MemoriesController < ApplicationController
  before_action :store_memory_index_path, only: :index

  def index
    redirect_to memories_path if params[:query].blank?
    @memories = memories.page(params[:page])
  end

  def show
    @memory = memories.find(params[:id])
    raise ActiveRecord::RecordNotFound unless viewable?(@memory)

    @query = params[:query]
  end

  private

  def search_results
    @results ||= SearchResults.new(params[:query])
  end

  def memories
    search_results.memory_results
  end

  def viewable?(memory)
    memory.publicly_visible? || current_user.try(:can_modify?, memory)
  end
end
