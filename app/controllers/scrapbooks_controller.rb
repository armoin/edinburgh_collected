class ScrapbooksController < ApplicationController
  before_action :store_scrapbook_index_path, only: :index
  before_action :store_memory_index_path, only: :show

  def index
    @scrapbooks = Scrapbook.all.page(params[:page]).per(30)
  end

  def show
    @scrapbook = Scrapbook.find(params[:id])
  end
end

