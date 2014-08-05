class User::AuthenticatedUserController < ApplicationController
  before_filter :authenticate!

  private

  def authenticate!
    return if logged_in?
    redirect_to login_url, alert: 'You must be logged in to access that.'
  end
end
