class Search::ScrapbooksController < ApplicationController
  before_action :store_scrapbook_index_path, only: :index

  def index
    redirect_to scrapbooks_path if params[:query].blank?
    @scrapbooks = scrapbooks.text_search(params[:query]).page(params[:page]).per(30)
  end

  private

  def scrapbooks
    Scrapbook.approved
  end
end

