class Users::MemoriesController < Users::MainController
  before_action :store_memory_index_path, only: :index
  
  def index
    requested_user = fetch_user
    
    if requested_user == current_user
      redirect_to my_memories_path
    else
      @presenter = UserMemoriesPresenter.new(requested_user, current_user, params[:page])
      render 'memories/user_index'
    end
  end
end
