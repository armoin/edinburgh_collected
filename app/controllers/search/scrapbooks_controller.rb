class Search::ScrapbooksController < ApplicationController
  before_action :store_scrapbook_index_path, only: :index

  def index
    redirect_to scrapbooks_path if params[:query].blank?
    @results = SearchResults.new('scrapbooks', params[:query], params[:page])
  end
end

