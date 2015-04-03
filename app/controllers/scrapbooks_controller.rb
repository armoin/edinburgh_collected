class ScrapbooksController < ApplicationController
  before_action :store_scrapbook_index_path, only: :index
  before_action :store_memory_index_path, only: :show

  def index
    scrapbooks = Scrapbook.publicly_visible
    memory_fetcher = ApprovedScrapbookMemoryFetcher.new(scrapbooks)
    @presenter = ScrapbookIndexPresenter.new(scrapbooks, memory_fetcher, params[:page])
  end

  def show
    @scrapbook = Scrapbook.publicly_visible.find(params[:id])
    @memories = Kaminari.paginate_array(scrapbook_memories).page(params[:page])
  end

  private

  def scrapbook_memories
    @scrapbook.approved_ordered_memories
  end
end

