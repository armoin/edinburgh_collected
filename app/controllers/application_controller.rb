class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :logout_if_access_denied, if: ->{ current_user.present? }

  include SessionHelper

  respond_to :html, :js, :json, :geojson

  rescue_from ActiveRecord::RecordNotFound do
    respond_with do |format|
      format.html    { render 'exceptions/not_found', :status => :not_found }
      format.js      { head :not_found }
      format.json    { head :not_found }
      format.geojson { head :not_found }
    end
  end

  private

  def logout_if_access_denied
    if current_user.access_denied?
      access_denied_reason = current_user.access_denied_reason
      logout
      redirect_to :signin, alert: access_denied_reason
    end
  end
end
