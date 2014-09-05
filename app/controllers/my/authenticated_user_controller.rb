class My::AuthenticatedUserController < ApplicationController
  before_action :require_login

  private

  def not_authenticated
    redirect_to login_path, alert: "Please login first"
  end
end
