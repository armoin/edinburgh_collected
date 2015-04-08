class My::ScrapbooksController < My::AuthenticatedUserController
  before_action :store_scrapbook_index_path, only: :index
  before_action :store_memory_index_path, only: :show
  before_action :assign_scrapbook, only: [:show, :edit, :update, :destroy]

  def index
    scrapbooks = current_user.scrapbooks.by_last_updated
    memory_fetcher = ScrapbookMemoryFetcher.new(scrapbooks, current_user.id)
    @presenter = ScrapbookIndexPresenter.new(scrapbooks, memory_fetcher, params[:page])
  end

  def show
    @memories = Kaminari.paginate_array(scrapbook_memories).page(params[:page])
    render 'scrapbooks/show'
  end

  def new
    @scrapbook = Scrapbook.new
  end

  def create
    @scrapbook = Scrapbook.new(scrapbook_params)
    @scrapbook.user = current_user
    respond_to do |format|
      if @scrapbook.save
        format.html { redirect_to my_scrapbook_path(@scrapbook), notice: 'Scrapbook created successfully.' }
        format.js
      else
        format.html { render :new }
        format.js { render 'error', status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @scrapbook.update(scrapbook_params)
      redirect_to my_scrapbook_path(@scrapbook)
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

  def scrapbook_memories
    @scrapbook.ordered_memories
  end
end

