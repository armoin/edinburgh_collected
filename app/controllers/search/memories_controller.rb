class Search::MemoriesController < ApplicationController
  before_action :store_memory_index_path, only: :index

  def index
    redirect_to memories_path if params[:query].blank?
    @results = SearchResults.new('memories', params[:query], params[:page])
  end
end

