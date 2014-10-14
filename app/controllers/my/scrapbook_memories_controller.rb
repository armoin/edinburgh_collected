class My::ScrapbookMemoriesController < My::AuthenticatedUserController
  def create
    @scrapbook = current_user.scrapbooks.find(scrapbook_id)
    @scrapbook.memories << memory
    respond_to do |format|
      if @scrapbook.save
        format.json { render json: @scrapbook }
      else
        format.json { render json: {}, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    scrapbook_memory = ScrapbookMemory.find(params[:id])
    @scrapbook = scrapbook_memory.scrapbook
    if current_user.scrapbooks.include?(@scrapbook) && scrapbook_memory.destroy
      redirect_to edit_my_scrapbook_path(@scrapbook), notice: 'Memory successfully removed'
    else
      redirect_to edit_my_scrapbook_path(@scrapbook), alert: 'Could not remove memory'
    end
  end

  private

  def scrapbook_id
    scrapbook_memory_params[:scrapbook_id]
  end

  def memory_id
    scrapbook_memory_params[:memory_id]
  end

  def memory
    Memory.find(memory_id)
  end

  def scrapbook_memory_params
    @scrapbook_memory_params ||= ScrapbookMemoryParamCleaner.clean(params)
  end
end

