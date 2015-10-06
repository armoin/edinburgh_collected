class My::MemoriesController < My::AuthenticatedUserController
  before_action :store_memory_index_path, only: :index
  before_action :assign_memory, only: [:show, :edit, :update, :destroy]

  def index
    @memories = current_user.memories.by_last_created.page(params[:page])
    @scrapbooks_count = current_user.scrapbooks.count
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
    if @memory.update(memory_params)
      redirect_to redirect_show_path
    else
      render :edit
    end
  end

  def destroy
    if @memory.destroy
      redirect_to redirect_index_path, notice: 'Successfully deleted'
    else
      redirect_to redirect_index_path, alert: 'Could not delete'
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

  def redirect_index_path
    if current_user.owns?(@memory)
      my_memories_path
    else
      current_memory_index_path
    end
  end

  def redirect_show_path
    if current_user.owns?(@memory)
      my_memory_path(@memory)
    elsif current_user.is_admin?
      admin_moderation_memory_path(@memory)
    else
      root_path
    end
  end
end

