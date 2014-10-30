class Admin::AuthenticatedAdminController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    not_authenticated unless current_user && current_user.is_admin?
  end

  def not_authenticated
    redirect_to signin_path, alert: "You must be signed in as an administrator to do that"
  end
end

