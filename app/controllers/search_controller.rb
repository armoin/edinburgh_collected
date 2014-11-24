class SearchController < ApplicationController
  def index
    @memories = Memory.search(params[:query]).page(params[:current_page]).per(30)
    render 'memories/index'
  end
end

