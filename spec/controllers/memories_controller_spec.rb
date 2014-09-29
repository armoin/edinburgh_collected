require 'rails_helper'

describe MemoriesController do
  let(:user)     { Fabricate.build(:user) }

  describe 'GET index' do
    let(:memories) { Fabricate.times(2, :photo_memory, user: user) }

    before(:each) do
      allow(Memory).to receive(:all).and_return(memories)
    end

    it "fetches the memories and assigns them" do
      get :index
      expect(assigns(:memories)).to eql(memories)
    end

    context 'when request is for HTML' do
      it "is successful" do
        get :index
        expect(response).to be_success
        expect(response.status).to eql(200)
      end

      it "renders the index page" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when request is for JSON' do
      it 'is successful' do
        get :index, format: :json
        expect(response).to be_success
        expect(response.status).to eql(200)
      end

      it "provides JSON" do
        get :index, format: :json
        expect(response.content_type).to eql('application/json')
      end
    end
  end

  describe 'GET show' do
    let(:memory) { Fabricate.build(:photo_memory, user: user) }
    let(:format) { :html }

    before :each do
      allow(Memory).to receive(:find) { memory }
      get :show, id: '123', format: format
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

      context "when requesting HTML" do
        it "renders the show page" do
          expect(response).to render_template(:show)
        end
      end

      context "when requesting JSON" do
        let(:format) { :json }

        it "provides JSON" do
          expect(response.content_type).to eql('application/json')
        end
      end
    end

    context "fetch is not successful" do
      before :each do
        allow(Memory).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
      end

      context "when requesting HTML" do
        before :each do
          get :show, id: '123'
        end

        it "renders the not found page" do
          expect(response).to render_template('exceptions/not_found')
        end

        it "returns an error status" do
          expect(response.status).to eq(404)
        end
      end

      context "when requesting JSON" do
        it "returns an error status" do
          get :show, id: '123', format: :json
          expect(response.status).to eq(404)
        end
      end
    end
  end
end
