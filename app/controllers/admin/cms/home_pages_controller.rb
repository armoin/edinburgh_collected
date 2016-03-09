class Admin::Cms::HomePagesController < Admin::AuthenticatedAdminController
  def index
    @home_pages = HomePage.order(:updated_at).includes(:featured_memory)
  end

  def show
    home_page = HomePage.find(params[:id])
    @home_page_presenter = HomePagePresenter.new(home_page)
  end
end
