require 'rails_helper'

describe MemoriesController do
  describe 'GET index' do
    let(:expected) { [Memory.new, Memory.new] }

    before(:each) do
      allow(Memory).to receive(:all).and_return(expected)
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

    it "fetches the memories and assigns them" do
      get :index
      expect(assigns(:memories)).to eql(expected)
    end
  end

  describe 'GET show' do
    let(:memory) { Memory.new }

    before :each do
      allow(Memory).to receive(:find) { memory }
      get :show, id: '123'
    end

    it "is successful" do
      expect(response).to be_success
      expect(response.status).to eql(200)
    end

    it "fetches the requested memory" do
      expect(Memory).to have_received(:find).with('123')
    end

    context "fetch is successful" do
      it "assigns fetched memory" do
        expect(assigns(:memory)).to eql(memory)
      end

      it "renders the show page" do
        expect(response).to render_template(:show)
      end
    end

    context "fetch is not successful" do
      it "renders the not found page" do
        allow(Memory).to receive(:find).and_raise('error')
        get :show, id: '123'
        expect(response).to render_template('memories/not_found')
      end
    end
  end
end
