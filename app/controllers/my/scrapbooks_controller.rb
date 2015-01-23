class My::ScrapbooksController < My::AuthenticatedUserController
  before_action :store_scrapbook_index_path, only: :index
  before_action :store_memory_index_path, only: :show
  before_action :assign_scrapbook, only: [:edit, :update, :destroy]

  def index
    @scrapbooks = current_user.scrapbooks.page(params[:page]).per(30)
  end

  def create
    @scrapbook = Scrapbook.new(scrapbook_params)
    @scrapbook.user = current_user
    respond_to do |format|
      if @scrapbook.save
        format.js
      else
        format.js { render 'error', status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @scrapbook.update(scrapbook_params)
      redirect_to scrapbook_path(@scrapbook)
    else
      render :edit
    end
  end

  def destroy
    opts = {}
    if @scrapbook.destroy
      opts = {notice: 'Successfully deleted'}
    else
      opts = {alert: 'Could not delete'}
    end
    redirect_to current_scrapbook_index_path, opts
  end

  private

  def assign_scrapbook
    @scrapbook = Scrapbook.find(params[:id])
    raise ActiveRecord::RecordNotFound unless current_user.can_modify?(@scrapbook)
  end

  def scrapbook_params
    ScrapbookParamCleaner.clean(params)
  end
end

