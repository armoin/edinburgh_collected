class My::MemoriesController < My::AuthenticatedUserController
  before_action :assign_memories, only: :index
  before_action :assign_memory, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
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
    if @memory.update_attributes(memory_params)
      redirect_to my_memories_url
    else
      render :edit
    end
  end

  def destroy
    if @memory.destroy
      redirect_to my_memories_url, notice: 'Successfully deleted'
    else
      redirect_to my_memories_url, alert: 'Could not delete'
    end
  end

  private

  def assign_memories
    @memories = memories.by_recent
  end

  def assign_memory
    @memory = memories.find(params[:id])
  end

  def memories
    current_user.memories
  end

  def memory_params
    MemoryParamCleaner.clean(params)
  end
end

