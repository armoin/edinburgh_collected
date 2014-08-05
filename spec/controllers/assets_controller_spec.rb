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
end
