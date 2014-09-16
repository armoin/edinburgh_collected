class My::ScrapbooksController < My::AuthenticatedUserController
  def index
    @scrapbooks = current_user.scrapbooks
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

  private

  def scrapbook_params
    ScrapbookParamCleaner.clean(params)
  end
end

