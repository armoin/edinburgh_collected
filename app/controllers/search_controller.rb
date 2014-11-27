class SearchController < ApplicationController
  def index
    redirect_to memories_path if params[:query].blank?
    @memories = Memory.approved.text_search(params[:query]).page(params[:page]).per(30)
  end
end

