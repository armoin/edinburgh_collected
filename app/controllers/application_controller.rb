class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  respond_to :html, :json, :geojson

  rescue_from ActiveRecord::RecordNotFound do
    respond_with do |format|
      format.html    { render 'exceptions/not_found', :status => :not_found }
      format.json    { head status: :not_found }
      format.geojson { head status: :not_found }
    end
  end
end
