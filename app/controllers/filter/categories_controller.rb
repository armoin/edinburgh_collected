class Filter::CategoriesController < ApplicationController
  def index
    redirect_to memories_path if params[:category].blank?
    @memories = Memory.filter_by_category(params[:category]).page(params[:page])
  end
end
