class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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

  def wrap_and_paginate_scrapbooks(collection, presenter)
    decorated = collection.map {|scrapbook| presenter.new(scrapbook)}
    Kaminari.paginate_array(decorated).page(params[:page])
  end
end
