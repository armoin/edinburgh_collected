class Search::ScrapbooksController < ApplicationController
  before_action :store_scrapbook_index_path, only: :index

  def index
    redirect_to scrapbooks_path if params[:query].blank?
    @results = SearchResults.new(params[:query])
    @scrapbooks = @results.scrapbook_results.page(params[:page])
  end
end
