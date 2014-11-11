class Admin::Moderation::MemoriesController < Admin::AuthenticatedAdminController
  def index
    @memories = Memory.unmoderated
  end

  def moderated
    @memories = Memory.moderated.by_recent
    render :index
  end

  def show
    @memory = Memory.find(params[:id])
  end

  def approve
    memory = Memory.find(params[:id])
    respond_to do |format|
      if memory.approve!
        format.html { redirect_to admin_moderation_path, notice: 'Memory approved' }
        format.json { render json: memory }
      else
        format.html { redirect_to admin_moderation_path, alert: 'Could not approve memory' }
        format.json { render json: 'Unable to approve', status: :unprocessable_entity }
      end
    end
  end

  def reject
    memory = Memory.find(params[:id])
    respond_to do |format|
      if memory.reject!(params[:reason])
        format.html { redirect_to admin_moderation_path, notice: 'Memory rejected' }
        format.json { render json: memory }
      else
        format.html { redirect_to admin_moderation_path, alert: 'Could not reject memory' }
        format.json { render json: 'Unable to reject', status: :unprocessable_entity }
      end
    end
  end

  def unmoderate
    memory = Memory.find(params[:id])
    respond_to do |format|
      if memory.unmoderate!
        format.html { redirect_to admin_moderation_path, notice: 'Memory unmoderated' }
        format.json { render json: memory }
      else
        format.html { redirect_to admin_moderation_path, alert: 'Could not unmoderate memory' }
        format.json { render json: 'Unable to unmoderate', status: :unprocessable_entity }
      end
    end
  end

  private

  def state
    params[:state] || ModerationStateMachine::DEFAULT_STATE
  end
end

