class ScrapbooksController < ApplicationController
  before_action :store_scrapbook_index_path, only: :index
  before_action :store_memory_index_path, only: :show

  def index
    @scrapbooks = wrap_and_paginate_scrapbooks(Scrapbook.approved, ScrapbookCoverPresenter)
  end

  def show
    @scrapbook = Scrapbook.find(params[:id])
  end
end

