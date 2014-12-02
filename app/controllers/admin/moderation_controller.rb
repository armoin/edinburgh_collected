class Admin::ModerationController < Admin::AuthenticatedAdminController
  before_action :store_memory_index_path, only: [:index, :moderated]

  def index
    @items = Memory.unmoderated
  end

  def moderated
    @items = Memory.moderated.sort{|a,b| b.last_moderated_at <=> a.last_moderated_at}
    render :index
  end
end

