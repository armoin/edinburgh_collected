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
end
