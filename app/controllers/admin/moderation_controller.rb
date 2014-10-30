class Admin::ModerationController < Admin::AuthenticatedAdminController
  def index
    @memories = Memory.unmoderated
  end
end

