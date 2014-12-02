class ScrapbooksController < ApplicationController
  before_action :store_memory_index_path, only: :show

  def index
    @scrapbooks = Scrapbook.all
  end

  def show
    @scrapbook = Scrapbook.find(params[:id])
  end
end

