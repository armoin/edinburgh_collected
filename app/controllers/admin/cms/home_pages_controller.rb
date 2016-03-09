class Admin::Cms::HomePagesController < Admin::AuthenticatedAdminController
  def index
    @home_pages = HomePage.order(:updated_at)
  end
end
