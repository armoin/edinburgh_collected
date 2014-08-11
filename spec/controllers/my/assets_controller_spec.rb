require 'rails_helper'

describe My::AssetsController do
  before { @user = Fabricate.build(:user) }

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
        login_user
        allow(@user).to receive(:assets).and_return(stub_assets)
        get :index
      end

      it 'is successful' do
        expect(response).to be_success
      end

      it "fetches the user's assets" do
        expect(@user).to have_received(:assets)
      end

      it "assigns the returned assets" do
        expect(assigns[:assets]).to eql(stub_assets)
      end

      it "renders the index page" do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET new' do
    context 'when not logged in' do
      it 'asks user to login' do
        get :new
        expect(response).to redirect_to(:login)
      end
    end

    context 'when logged in' do
      before :each do
        login_user
        get :new
      end

      it "assigns a new Asset" do
        expect(assigns(:asset)).to be_a(Asset)
      end

      it "is successful" do
        expect(response).to be_success
        expect(response.status).to eql(200)
      end

      it "renders the new page" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST create' do
    let(:asset_params) {{ title: 'A title' }}

    context 'when not logged in' do
      it 'asks user to login' do
        post :create, asset: asset_params
        expect(response).to redirect_to(:login)
      end
    end

    context 'when logged in' do
      let(:asset_stub)  { double('asset', 'user=' => true) }

      before :each do
        login_user
        allow(Asset).to receive(:new).and_return(asset_stub)
        allow(asset_stub).to receive(:save).and_return(true)
        post :create, asset: asset_params
      end

      it "builds a new Asset with the given params" do
        expect(Asset).to have_received(:new).with(asset_params)
      end

      it "assigns the asset" do
        expect(assigns(:asset)).to eql(asset_stub)
      end

      it "assigns the current user" do
        expect(asset_stub).to have_received('user=').with(@user)
      end

      it "saves the Asset" do
        expect(asset_stub).to have_received(:save)
      end

      context "save is successful" do
        it "redirects to the user's assets page" do
          expect(response).to redirect_to(my_assets_url)
        end
      end

      context "save is not successful" do
        it "re-renders the new form" do
          allow(asset_stub).to receive(:save).and_return(false)
          post :create, asset: asset_params
          expect(response).to render_template(:new)
        end
      end
    end
  end
end

