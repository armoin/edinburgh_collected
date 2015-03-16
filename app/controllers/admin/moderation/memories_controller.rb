class Admin::Moderation::MemoriesController < Admin::AuthenticatedAdminController
  before_action :assign_memory, except: [:index, :moderated]
  before_action :store_memory_index_path, only: [:index, :moderated]

  def index
    @items = Memory.unmoderated
  end

  def show
  end

  def moderated
    @items = Memory.moderated.by_recent
    render :index
  end

  def approve
    respond_to do |format|
      if @memory.approve!(current_user)
        format.html { redirect_to admin_moderation_memories_path, notice: 'Memory approved' }
        format.json { render json: @memory }
      else
        format.html { redirect_to admin_moderation_memories_path, alert: 'Could not approve memory' }
        format.json { render json: 'Unable to approve', status: :unprocessable_entity }
      end
    end
  end

  def reject
    respond_to do |format|
      if @memory.reject!(current_user, params[:reason])
        format.html { redirect_to admin_moderation_memories_path, notice: 'Memory rejected' }
        format.json { render json: @memory }
      else
        format.html { redirect_to admin_moderation_memories_path, alert: 'Could not reject memory' }
        format.json { render json: 'Unable to reject', status: :unprocessable_entity }
      end
    end
  end

  def unmoderate
    respond_to do |format|
      if @memory.unmoderate!(current_user)
        format.html { redirect_to moderated_admin_moderation_memories_path, notice: 'Memory unmoderated' }
        format.json { render json: @memory }
      else
        format.html { redirect_to moderated_admin_moderation_memories_path, alert: 'Could not unmoderate memory' }
        format.json { render json: 'Unable to unmoderate', status: :unprocessable_entity }
      end
    end
  end

  private

  def assign_memory
    @memory ||= Memory.find(params[:id])
  end

  def memory_params
    MemoryParamCleaner.clean(params)
  end
end

