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
end
