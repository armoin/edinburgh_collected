class Users::ScrapbooksController < Users::MainController
  before_action :store_scrapbook_index_path, only: :index
  
  def index
    @requested_user = fetch_user
    redirect_to my_scrapbooks_path if @requested_user == current_user
    scrapbooks = @requested_user.scrapbooks.approved.page(params[:page])
    memory_fetcher = ApprovedScrapbookMemoryFetcher.new(scrapbooks)
    @presenter = ScrapbookIndexPresenter.new(scrapbooks, memory_fetcher, params[:page])
  end
end
