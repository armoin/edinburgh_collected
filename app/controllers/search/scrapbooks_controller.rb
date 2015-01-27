class Search::ScrapbooksController < ApplicationController
  before_action :store_scrapbook_index_path, only: :index

  def index
    redirect_to scrapbooks_path if params[:query].blank?
    @results = SearchResults.new(params[:query])
    @scrapbooks = wrap_and_paginate_scrapbooks(@results.scrapbook_results, ScrapbookCoverPresenter)
  end
end
