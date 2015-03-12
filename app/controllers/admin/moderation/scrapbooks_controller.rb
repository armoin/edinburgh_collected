class Admin::Moderation::ScrapbooksController < Admin::AuthenticatedAdminController
  before_action :store_scrapbook_index_path, only: [:index, :moderated]

  def index
    @items = Scrapbook.unmoderated
  end

  def moderated
    @items = Scrapbook.moderated.by_recent
    render :index
  end

  def show
    @scrapbook = Scrapbook.find(params[:id])
    @memories = Kaminari.paginate_array(@scrapbook.ordered_memories).page(params[:page])
  end
end

