class Search::MemoriesController < ApplicationController
  def index
    redirect_to memories_path if params[:query].blank?
    @memories = memories.text_search(params[:query]).page(params[:page]).per(30)
  end

  private

  def memories
    Memory.approved
  end
end

