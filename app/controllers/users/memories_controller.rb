class Users::MemoriesController < ApplicationController
  before_action :store_memory_index_path, only: :index

  def index
    requested_user = User.find(params[:user_id])

    redirect_to my_memories_path and return if requested_user == current_user
    raise ActiveRecord::RecordNotFound unless requested_user.publicly_visible?

    @presenter = UserMemoriesPresenter.new(requested_user, current_user, params[:page])
    render 'memories/user_index'
  end
end
