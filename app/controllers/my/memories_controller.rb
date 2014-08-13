class My::MemoriesController < My::AuthenticatedUserController
  before_filter :assign_memories, only: :index
  before_filter :assign_memory, only: [:show, :edit, :update]

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
      redirect_to my_memories_url
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

  private

  def assign_memories
    @memories = memories
  end

  def assign_memory
    @memory = memories.find(params[:id])
  end

  def memories
    current_user.memories
  end

  def memory_params
    params.require(:memory).permit(
      :title,
      :file_type,
      :source,
      :description,
      :year,
      :month,
      :day,
      :width,
      :height,
      :resolution,
      :device,
      :length,
      :is_readable,
      :attribution,
      :area_id,
      :location
    )
  end
end

