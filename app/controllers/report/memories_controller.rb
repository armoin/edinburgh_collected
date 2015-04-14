class Report::MemoriesController < ApplicationController
  include UserAuthenticator

  respond_to :html

  def edit
    @memory = Memory.find(params[:id])
  end

  def update
    @memory = Memory.find(params[:id])
    if @memory.report!(current_user, memory_params[:moderation_reason])
      redirect_to current_memory_index_path, notice: 'Thank you for reporting your concern.'
    else
      render :edit
    end
  end

  private

  def memory_params
    MemoryParamCleaner.clean(params)
  end
end
