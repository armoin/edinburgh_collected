class Admin::Moderation::MemoriesController < Admin::AuthenticatedAdminController
  INDEXES = [:index, :moderated, :reported]

  before_action :assign_memory, except: INDEXES
  before_action :store_memory_index_path, only: INDEXES

  def index
    @items = memories.unmoderated.order(created_at: :desc)
  end

  def moderated
    @items = memories.moderated.by_last_moderated
    render :index
  end

  def reported
    @items = memories.reported.by_last_reported
    render :index
  end

  def show
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

  def memories
    Memory.includes(:user, :moderated_by)
  end

  def memory_params
    MemoryParamCleaner.clean(params)
  end
end

