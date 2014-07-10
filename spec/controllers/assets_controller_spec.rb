require 'rails_helper'

describe AssetsController do
  describe 'GET index' do
    let(:expected) { [Asset.new, Asset.new] }

    before(:each) do
      allow(Asset).to receive(:all) { expected }
    end

    it "is successful" do
      get :index
      expect(response).to be_success
      expect(response.status).to eql(200)
    end

    it "renders the index page" do
      get :index
      expect(response).to render_template(:index)
    end

    it "fetches the assets and assigns them" do
      get :index
      expect(assigns(:assets)).to eql(expected)
    end
  end

  describe 'GET show' do
    let(:asset) { Asset.new }

    before :each do
      allow(Asset).to receive(:find) { asset }
      get :show, id: '123'
    end

    it "is successful" do
      expect(response).to be_success
      expect(response.status).to eql(200)
    end

    it "fetches the requested asset" do
      expect(Asset).to have_received(:find).with('123')
    end

    context "fetch is successful" do
      it "assigns fetched asset" do
        expect(assigns(:asset)).to eql(asset)
      end

      it "renders the show page" do
        expect(response).to render_template(:show)
      end
    end

    context "fetch is not successful" do
      it "renders the not found page" do
        allow(Asset).to receive(:find).and_raise('error')
        get :show, id: '123'
        expect(response).to render_template('assets/not_found')
      end
    end
  end

  describe 'GET new' do
    before :each do
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

  describe 'POST create' do
    let(:asset_stub)   { double('asset', save: true) }
    let(:asset_params) {{ title: 'A title' }}

    before :each do
      allow(Asset).to receive(:new) { asset_stub }
      post :create, asset: asset_params
    end

    it "builds a new Asset with the given params" do
      expect(Asset).to have_received(:new).with(asset_params)
    end

    it "saves the Asset" do
      expect(asset_stub).to have_received(:save)
    end

    context "save is successful" do
      it "redirects to the /assets page" do
        expect(response).to redirect_to(assets_url)
      end
    end

    context "save is not successful" do
      let(:asset_stub) { double('asset', save: false) }

      it "assigns the asset" do
        expect(assigns(:asset)).to eql(asset_stub)
      end

      it "re-renders the new form" do
        expect(response).to render_template(:new)
      end
    end
  end
end
