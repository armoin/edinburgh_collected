class My::MemoriesController < My::AuthenticatedUserController
  def index
    @memories = current_user.memories
  end

  def show
    @memory = current_user.memories.find(params[:id])
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

  private

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

