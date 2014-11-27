class SearchController < ApplicationController
  def index
    @memories = Memory.approved.text_search(params[:query]).page(params[:page]).per(30)
  end
end

