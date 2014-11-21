class Admin::Moderation::MemoriesController < Admin::AuthenticatedAdminController
  before_filter :assign_memory

  def show
  end

  def edit
  end

  def update
    if @memory.update(memory_params)
      redirect_to admin_moderation_memory_path(@memory.id)
    else
      render :edit
    end
  end

  def destroy
    if @memory.destroy
      redirect_to admin_unmoderated_url, notice: 'Successfully deleted'
    else
      redirect_to admin_unmoderated_url, alert: 'Could not delete'
    end
  end

  def approve
    respond_to do |format|
      if @memory.approve!
        format.html { redirect_to redirect_path, notice: 'Memory approved' }
        format.json { render json: @memory }
      else
        format.html { redirect_to redirect_path, alert: 'Could not approve memory' }
        format.json { render json: 'Unable to approve', status: :unprocessable_entity }
      end
    end
  end

  def reject
    respond_to do |format|
      if @memory.reject!(params[:reason])
        format.html { redirect_to redirect_path, notice: 'Memory rejected' }
        format.json { render json: @memory }
      else
        format.html { redirect_to redirect_path, alert: 'Could not reject memory' }
        format.json { render json: 'Unable to reject', status: :unprocessable_entity }
      end
    end
  end

  def unmoderate
    respond_to do |format|
      if @memory.unmoderate!
        format.html { redirect_to redirect_path, notice: 'Memory unmoderated' }
        format.json { render json: @memory }
      else
        format.html { redirect_to redirect_path, alert: 'Could not unmoderate memory' }
        format.json { render json: 'Unable to unmoderate', status: :unprocessable_entity }
      end
    end
  end

  private

  def assign_memory
    @memory ||= Memory.find(params[:id])
  end

  def state
    params[:state] || ModerationStateMachine::DEFAULT_STATE
  end

  def redirect_path
    if @memory.previous_state == 'unmoderated'
      admin_unmoderated_path
    else
      admin_moderated_path
    end
  end

  def memory_params
    MemoryParamCleaner.clean(params)
  end
end

