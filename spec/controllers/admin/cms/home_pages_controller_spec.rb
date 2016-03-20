require 'rails_helper'

RSpec.describe Admin::Cms::HomePagesController do
  it 'requires the user to be authenticated as an administrator' do
    expect(subject).to be_a(Admin::AuthenticatedAdminController)
  end

  describe 'GET index' do
    context 'user must be an admin' do
      let(:perform_action) { get :index }

      it_behaves_like 'an admin only controller'
    end

    context 'when logged in as an admin' do
      let(:home_pages) { double('home_pages') }

      before :each do
        @user = Fabricate(:admin_user)
        login_user

        allow(HomePage).to receive(:order).and_return(home_pages)
        allow(home_pages).to receive(:includes).and_return(home_pages)

        get :index
      end

      it 'orders the home_pages by updated_at' do
        expect(HomePage).to have_received(:order).with(:updated_at)
      end

      it 'includes the featured memory' do
        expect(home_pages).to have_received(:includes).with(:featured_memory)
      end

      it 'assigns all home_page records' do
        expect(assigns(:home_pages)).to eq(home_pages)
      end

      it 'renders the index page' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET show' do
    let(:home_page)           { double('home_page') }
    let(:home_page_presenter) { double('home_page_presenter') }

    context 'user must be an admin' do
      let(:perform_action) { get :show, id: '123' }

      it_behaves_like 'an admin only controller'
    end

    context 'when logged in as an admin' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user

        allow(HomePage).to receive(:find).and_return(home_page)
        allow(HomePagePresenter).to receive(:new).and_return(home_page_presenter)

        get :show, id: '123'
      end

      it 'fetches the requested home page' do
        expect(HomePage).to have_received(:find).with('123')
      end

      it 'generates a home_page_presenter with the requested home_page' do
        expect(HomePagePresenter).to have_received(:new).with(home_page)
      end

      it 'assigns the presenter' do
        expect(assigns(:home_page_presenter)).to eq(home_page_presenter)
      end

      it 'renders the show page' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET new' do
    context 'user must be an admin' do
      let(:perform_action) { get :new }

      it_behaves_like 'an admin only controller'
    end

    context 'when logged in as an admin' do
      let(:home_page) { double('home_page') }

      before :each do
        @user = Fabricate(:admin_user)
        login_user

        get :new
      end

      it 'assigns a new blank home_page' do
        expect(assigns[:home_page]).to be_a_new(HomePage)
      end

      it 'renders the new page' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST create' do
    context 'user must be an admin' do
      let(:perform_action) { post :create }

      it_behaves_like 'an admin only controller'
    end

    context 'when logged in as an admin' do
      let(:home_page_params) do
        {
          featured_memory_id: '1',
          featured_scrapbook_id: '2'
        }
      end
      let(:home_page)   { double(id: 123) }
      let(:save_result) { true }

      before :each do
        @user = Fabricate(:admin_user)
        login_user

        allow(HomePage).to receive(:new).and_return(home_page)
        allow(home_page).to receive(:save).and_return(save_result)

        post :create, home_page: home_page_params
      end

      it 'builds a new home_page with the given params' do
        expect(HomePage).to have_received(:new).with(home_page_params)
      end

      it 'assigns the built home page' do
        expect(assigns(:home_page)).to eq(home_page)
      end

      it 'attempts to save the home page' do
        expect(home_page).to have_received(:save)
      end

      context 'when save is successful' do
        let(:save_result) { true }

        it 'displays a flash notice' do
          expect(flash[:notice]).to eq('Home page created.')
        end

        it 'redirects to the show page' do
          expect(response).to redirect_to(admin_cms_home_page_path(home_page))
        end
      end

      context 'when save is not successful' do
        let(:save_result) { false }

        it 'displays a flash alert' do
          expect(flash[:alert]).to eq('Unable to save this home page. Please see errors below.')
        end

        it 'renders the new page' do
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'GET edit' do
    context 'user must be an admin' do
      let(:perform_action) { get :edit, id: '123' }

      it_behaves_like 'an admin only controller'
    end

    context 'when logged in as an admin' do
      let(:home_page) { double('home_page') }

      before :each do
        @user = Fabricate(:admin_user)
        login_user

        allow(HomePage).to receive(:find).and_return(home_page)

        get :edit, id: '123'
      end

      it 'fetches and assigns the requested home_page' do
        expect(HomePage).to have_received(:find).with('123')
        expect(assigns[:home_page]).to eq(home_page)
      end

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PATCH update' do
    context 'user must be an admin' do
      let(:perform_action) { patch :update, id: '123' }

      it_behaves_like 'an admin only controller'
    end

    context 'when logged in as an admin' do
      let(:home_page_params) do
        {
          image_rotate: '0',
          image_scale: '2.158',
          image_w: '1140',
          image_h: '525',
          image_x: '56',
          image_y: '483'
        }
      end
      let(:home_page)   { double(id: 123) }
      let(:update_result) { true }

      before :each do
        @user = Fabricate(:admin_user)
        login_user

        allow(HomePage).to receive(:find).and_return(home_page)
        allow(controller).to receive(:update_and_process_image).and_return(update_result)

        patch :update, id: '123', home_page: home_page_params
      end

      it 'fetches the requested home_page' do
        expect(HomePage).to have_received(:find).with('123')
      end

      it 'assigns the requested home_page' do
        expect(assigns[:home_page]).to eq(home_page)
      end

      it 'updates the homepage and processes the hero image' do
        expect(controller).to have_received(:update_and_process_image).with(home_page, home_page_params)
      end

      context 'when save is successful' do
        let(:update_result) { true }

        it 'displays a flash notice' do
          expect(flash[:notice]).to eq('Home page saved.')
        end

        it 'redirects to the show page' do
          expect(response).to redirect_to(admin_cms_home_page_path(home_page))
        end
      end

      context 'when save is not successful' do
        let(:update_result) { false }

        it 'displays a flash alert' do
          expect(flash[:alert]).to eq('Unable to save the home page.')
        end

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end
    end
  end
end
