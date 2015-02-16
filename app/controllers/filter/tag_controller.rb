class Filter::TagController < ApplicationController
  before_action :store_memory_index_path, only: :index

  def index
    redirect_to memories_path if params[:tag].blank?
    @memories = Memory.filter_by_tag(params[:tag]).page(params[:page])
  end
end
