require 'rails_helper'

describe User::AssetsController do
  describe 'GET index' do
    context 'when not logged in' do
      it 'asks user to login' do
        get :index
        expect(response).to redirect_to(:login)
      end
    end

    context 'when logged in' do
      let(:stub_assets) { double('assets') }

      before :each do
        login!
        allow(Asset).to receive(:user).and_return(stub_assets)
        get :index
      end

      it 'is successful' do
        expect(response).to be_success
      end

      it "fetches the user's assets" do
        expect(Asset).to have_received(:user).with(auth_token)
      end

      it "assigns the returned assets" do
        expect(assigns[:assets]).to eql(stub_assets)
      end

      it "renders the index page" do
        expect(response).to render_template(:index)
      end
    end
  end
end

