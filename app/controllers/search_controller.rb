class SearchController < ApplicationController
  def index
    @memories = Memory.text_search(params[:query]).page(params[:current_page]).per(30)
  end
end

