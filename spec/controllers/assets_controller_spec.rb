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

  describe 'GET new' do
    it "is successful" do
      get :new
      expect(response).to be_success
      expect(response.status).to eql(200)
    end

    it "renders the new page" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    before :each do
      allow(Asset).to receive(:create) { true }
    end

    it "creates a new Asset" do
      post :create, asset: {title: 'Test'}
      expect(Asset).to have_received(:create).with(title: 'Test')
    end

    it "redirects to the /assets page" do
      post :create
      expect(response).to redirect_to('/assets')
    end
  end
end
