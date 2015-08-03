class Scrapbooks::MemoriesController < ApplicationController
  def show
    @scrapbook = Scrapbook.find(params[:scrapbook_id])
    @memory = @scrapbook.memories.find(params[:id])
    raise ActiveRecord::RecordNotFound unless viewable?
    @page = params[:page]
  end

  private

  def viewable?
    @memory.publicly_visible? || current_user.try(:can_modify?, @memory)
  end
end
