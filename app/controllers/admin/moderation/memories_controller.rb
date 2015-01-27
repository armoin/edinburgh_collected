class Admin::Moderation::MemoriesController < Admin::AuthenticatedAdminController
  before_filter :assign_memory

  def approve
    respond_to do |format|
      if @memory.approve!
        format.html { redirect_to admin_unmoderated_path, notice: 'Memory approved' }
        format.json { render json: @memory }
      else
        format.html { redirect_to admin_unmoderated_path, alert: 'Could not approve memory' }
        format.json { render json: 'Unable to approve', status: :unprocessable_entity }
      end
    end
  end

  def reject
    respond_to do |format|
      if @memory.reject!(params[:reason])
        format.html { redirect_to admin_unmoderated_path, notice: 'Memory rejected' }
        format.json { render json: @memory }
      else
        format.html { redirect_to admin_unmoderated_path, alert: 'Could not reject memory' }
        format.json { render json: 'Unable to reject', status: :unprocessable_entity }
      end
    end
  end

  def unmoderate
    respond_to do |format|
      if @memory.unmoderate!
        format.html { redirect_to admin_moderated_path, notice: 'Memory unmoderated' }
        format.json { render json: @memory }
      else
        format.html { redirect_to admin_moderated_path, alert: 'Could not unmoderate memory' }
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

