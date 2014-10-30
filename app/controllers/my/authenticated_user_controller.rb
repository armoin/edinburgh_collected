class My::AuthenticatedUserController < ApplicationController
  before_action :require_login

  private

  def not_authenticated
    redirect_to signin_path, alert: "Please sign in first"
  end
end
