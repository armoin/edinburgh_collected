class Admin::ModerationController < Admin::AuthenticatedAdminController
  def index
    @memories = Memory.unmoderated
  end

  def approve
    memory = Memory.find(params[:id])
    if memory.approve!
      redirect_to admin_moderation_path, notice: 'Memory approved'
    else
      redirect_to admin_moderation_path, alert: 'Could not approve memory'
    end
  end
end

