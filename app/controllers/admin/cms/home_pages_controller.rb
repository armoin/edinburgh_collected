class Admin::Cms::HomePagesController < Admin::AuthenticatedAdminController
  include UpdateWithImage

  def index
    @home_pages = HomePage.order(:updated_at).includes(:featured_memory)
  end

  def show
    home_page = HomePage.find(params[:id])
    @home_page_presenter = HomePagePresenter.new(home_page)
  end

  def new
    @home_page = HomePage.new
  end

  def create
    @home_page = HomePage.new(home_page_params)
    if @home_page.save
      flash[:notice] = 'Home page created.'
      redirect_to admin_cms_home_page_path(@home_page)
    else
      flash[:alert] = 'Unable to save this home page. Please see errors below.'
      render :new
    end
  end

  def edit
    @home_page = HomePage.find(params[:id])
  end

  def update
    @home_page = HomePage.find(params[:id])
    if update_and_process_image(@home_page, home_page_params)
      flash[:notice] = 'Home page saved.'
      redirect_to admin_cms_home_page_path(@home_page)
    else
      flash[:alert] = 'Unable to save the home page.'
      render :edit
    end
  end

  def publish
    @home_page = HomePage.find(params[:id])
    if @home_page.publish
      flash[:notice] = 'Home page published.'
      redirect_to admin_cms_home_pages_path
    else
      flash[:alert] = "You need to select #{HomePage::REQUIRED_SCRAPBOOK_MEMORIES} scrapbook memories before you can publish this home page."
      render :edit
    end
  end

  def destroy
    home_page = HomePage.find(params[:id])
    home_page.destroy
    redirect_to admin_cms_home_pages_path
  end

  private

  def home_page_params
    params.require(:home_page).permit(
      :featured_memory_id,
      :featured_scrapbook_id,
      :featured_scrapbook_memory_ids,
      :image_rotate,
      :image_scale,
      :image_w,
      :image_h,
      :image_x,
      :image_y
    )
  end
end
