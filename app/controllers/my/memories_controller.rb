class My::MemoriesController < My::AuthenticatedUserController
  before_action :store_memory_index_path, only: :index
  before_action :assign_memory, only: [:show, :edit, :update, :destroy]

  def index
    @presenter = UserMemoriesPresenter.new(current_user, current_user, params[:page])
    render 'memories/user_index'
  end

  def new
    @memory = Photo.new
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
      redirect_to current_memory_index_path, notice: 'Successfully deleted'
    else
      redirect_to current_memory_index_path, alert: 'Could not delete'
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

