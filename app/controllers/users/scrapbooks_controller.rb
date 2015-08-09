class Users::ScrapbooksController < ApplicationController
  before_action :store_scrapbook_index_path, only: :index
  before_action :store_memory_index_path, only: :show

  before_action :assign_requested_user

  def index
    redirect_to my_scrapbooks_path and return if @requested_user == current_user

    scrapbooks = visible_scrapbooks_for_user.by_last_created
    memory_fetcher = ApprovedScrapbookMemoryFetcher.new(scrapbooks)
    @presenter = ScrapbookIndexPresenter.new(scrapbooks, memory_fetcher, params[:page])
  end

  def show
    redirect_to my_scrapbooks_path(params[:id]) and return if @requested_user == current_user

    @scrapbook = visible_scrapbooks_for_user.find(params[:id])
    @memories = Kaminari.paginate_array(@scrapbook.ordered_memories).page(params[:page])
  end

  private

  def assign_requested_user
    @requested_user = User.find(params[:user_id])
    raise ActiveRecord::RecordNotFound unless @requested_user.publicly_visible?
  end

  def visible_scrapbooks_for_user
    @requested_user.scrapbooks.publicly_visible
  end
end
