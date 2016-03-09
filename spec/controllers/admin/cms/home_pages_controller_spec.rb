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

        get :index
      end

      it 'orders the home_pages by updated_at' do
        expect(HomePage).to have_received(:order).with(:updated_at)
      end

      it 'assigns all home_page records' do
        expect(assigns(:home_pages)).to eq(home_pages)
      end

      it 'renders the index page' do
        expect(response).to render_template(:index)
      end
    end
  end
end
