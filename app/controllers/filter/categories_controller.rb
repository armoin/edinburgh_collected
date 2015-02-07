class Filter::CategoriesController < ApplicationController
  before_action :store_memory_index_path, only: :index

  def index
    redirect_to memories_path if params[:category].blank?
    @memories = Memory.filter_by_category(params[:category]).page(params[:page])
  end
end
