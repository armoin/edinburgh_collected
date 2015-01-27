class Search::MemoriesController < ApplicationController
  before_action :store_memory_index_path, only: :index

  def index
    redirect_to memories_path if params[:query].blank?
    @results = SearchResults.new(params[:query])
    @memories = @results.memory_results.page(params[:page])
  end
end

