class Filter::AreaController < ApplicationController
  before_action :store_memory_index_path, only: :index

  def index
    redirect_to memories_path if params[:area].blank?
    @memories = Memory.filter_by_area(params[:area]).page(params[:page])
  end
end
