class Users::MemoriesController < ApplicationController
  before_action :store_memory_index_path, only: :index
  before_action :assign_requested_user

  def index
    redirect_to my_memories_path and return if @requested_user == current_user

    @memories = memories.by_last_created.page(params[:page])
    @scrapbooks_count = scrapbooks.count
  end

  def show
    @memory = memories.find(params[:id])
    @page = params[:page]
  end

  private

  def assign_requested_user
    @requested_user = User.find(params[:user_id])
    raise ActiveRecord::RecordNotFound unless @requested_user.publicly_visible?
  end

  def memories
    @requested_user.memories.publicly_visible
  end

  def scrapbooks
    @requested_user.scrapbooks.publicly_visible
  end
end
