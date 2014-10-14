class ScrapbooksController < ApplicationController
  def index
    @scrapbooks = Scrapbook.all
  end

  def show
    @scrapbook = Scrapbook.find(params[:id])
  end
end

