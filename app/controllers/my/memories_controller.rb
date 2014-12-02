class My::MemoriesController < My::AuthenticatedUserController
  before_action :assign_memory, only: [:show, :edit, :update, :destroy]

  def index
    @memories = current_user.memories.by_recent.page(params[:page]).per(30)
  end

  def new
    @memory = Memory.new
  end

  def create
    @memory = Memory.new(memory_params)
    @memory.user = current_user
    if @memory.save
      if params[:commit] == 'Save And Add Another'
        redirect_to new_my_memory_url
      else
        redirect_to my_memories_url
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @memory.update(memory_params)
      redirect_to memory_path(@memory.id)
    else
      render :edit
    end
  end

  def destroy
    if @memory.destroy
      redirect_to current_index_path, notice: 'Successfully deleted'
    else
      redirect_to current_index_path, alert: 'Could not delete'
    end
  end

  private

  def assign_memory
    @memory = Memory.find(params[:id])
    raise ActiveRecord::RecordNotFound unless current_user.can_modify?(@memory)
  end

  def memory_params
    MemoryParamCleaner.clean(params)
  end
end

