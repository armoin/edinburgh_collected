class HomeController < ApplicationController
  before_action :store_memory_index_path, only: :index
  before_action :store_scrapbook_index_path, only: :index

  def index
  end
end
