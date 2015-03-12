class Admin::Moderation::ScrapbooksController < Admin::AuthenticatedAdminController
  before_action :store_scrapbook_index_path, only: [:index, :moderated]
  before_action :assign_scrapbook, except: [:index, :moderated]

  def index
    @items = Scrapbook.unmoderated
  end

  def moderated
    @items = Scrapbook.moderated.by_recent
    render :index
  end

  def show
    @memories = Kaminari.paginate_array(@scrapbook.ordered_memories).page(params[:page])
  end

  def approve
    if @scrapbook.approve!
      message = {notice: 'Scrapbook approved'}
    else
      message = {alert: 'Could not approve scrapbook'}
    end
    redirect_to admin_moderation_scrapbooks_path, message
  end

  def reject
    if @scrapbook.reject!(params[:reason])
      message = {notice: 'Scrapbook rejected'}
    else
      message = {alert: 'Could not reject scrapbook'}
    end
    redirect_to admin_moderation_scrapbooks_path, message
  end

  def unmoderate
    if @scrapbook.unmoderate!
      message = {notice: 'Scrapbook unmoderated'}
    else
      message = {alert: 'Could not unmoderate scrapbook'}
    end
    redirect_to admin_moderation_scrapbooks_path, message
  end

  private

  def assign_scrapbook
    @scrapbook = Scrapbook.find(params[:id])
  end
end
