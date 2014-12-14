class My::ScrapbooksController < My::AuthenticatedUserController
  before_action :store_scrapbook_index_path, only: :index
  before_action :store_memory_index_path, only: :show

  def index
    @scrapbooks = current_user.scrapbooks.page(params[:page]).per(30)
  end

  def show
    @scrapbook = current_user.scrapbooks.find(params[:id])
  end

  def create
    @scrapbook = Scrapbook.new(scrapbook_params)
    @scrapbook.user = current_user
    respond_to do |format|
      if @scrapbook.save
        format.json { render json: @scrapbook }
      else
        format.json { render json: @scrapbook.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @scrapbook = current_user.scrapbooks.find(params[:id])
  end

  def update
    @scrapbook = current_user.scrapbooks.find(params[:id])
    if @scrapbook.update(scrapbook_params)
      redirect_to my_scrapbook_path(@scrapbook)
    else
      render :edit
    end
  end

  def destroy
    @scrapbook = current_user.scrapbooks.find(params[:id])
    if @scrapbook.destroy
      redirect_to my_scrapbooks_url, notice: 'Successfully deleted'
    else
      redirect_to my_scrapbooks_url, alert: 'Could not delete'
    end
  end

  private

  def scrapbook_params
    ScrapbookParamCleaner.clean(params)
  end
end

