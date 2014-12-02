class Search::MemoriesController < ApplicationController
  before_action :store_memory_index_path, only: :index

  def index
    redirect_to memories_path if params[:query].blank?
    @memories = memories.text_search(params[:query]).page(params[:page]).per(30)
  end

  private

  def memories
    Memory.approved
  end
end

