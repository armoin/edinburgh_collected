require 'rails_helper'

describe MemoriesController do
  let(:approved_memories) { double('approved_memories') }
  let(:sorted_memories)   { double('sorted_memories') }
  let(:format)            { :html }

  before(:each) do
    allow(Memory).to receive(:approved).and_return(approved_memories)
    allow(sorted_memories).to receive(:page).and_return(sorted_memories)
    allow(sorted_memories).to receive(:per).and_return(sorted_memories)
  end

  describe 'GET index' do
    before(:each) do
      allow(approved_memories).to receive(:by_recent).and_return(sorted_memories)
      get :index, format: format
    end

    it 'sets the current memory index path' do
      expect(session[:current_memory_index_path]).to eql(memories_path(format: format))
    end

    it "fetches the approved memories" do
      expect(Memory).to have_received(:approved)
    end

    it "orders them by most recent first" do
      expect(approved_memories).to have_received(:by_recent)
    end

    it "paginates the results 30 to a page" do
      expect(sorted_memories).to have_received(:page)
      expect(sorted_memories).to have_received(:per).with(30)
    end

    it "assigns the approved and sorted memories" do
      expect(assigns(:memories)).to eql(sorted_memories)
    end

    context 'when request is for HTML' do
      let(:format) { :html }

      it "is successful" do
        expect(response).to be_success
        expect(response.status).to eql(200)
      end

      it "renders the index page" do
        expect(response).to render_template(:index)
      end
    end

    context 'when request is for JSON' do
      let(:format) { :json }

      it 'is successful' do
        expect(response).to be_success
        expect(response.status).to eql(200)
      end

      it "provides JSON" do
        expect(response.content_type).to eql('application/json')
      end
    end

    context 'when request is for GeoJSON' do
      let(:format) { :geojson }

      it 'is successful' do
        expect(response).to be_success
        expect(response.status).to eql(200)
      end

      it "provides GeoJSON" do
        expect(response.content_type).to eql('text/geojson')
      end
    end
  end

  describe 'GET show' do
    let(:user)   { Fabricate.build(:user) }
    let(:memory) { Fabricate.build(:photo_memory) }

    it 'does not set the current memory index path' do
      expect(session[:current_memory_index_path]).to be_nil
    end

    it "fetches the requested memory" do
      allow(Memory).to receive(:find).and_return(memory)
      get :show, id: '123', format: format
      expect(Memory).to have_received(:find).with('123')
    end

    context "when record is found" do
      before :each do
        allow(Memory).to receive(:find).and_return(memory)
      end

      it "assigns fetched memory" do
        get :show, id: '123', format: format
        expect(assigns(:memory)).to eql(memory)
      end

      context 'and memory is approved' do
        before :each do
          memory.save!
          memory.approve!
          get :show, id: '123', format: format
        end

        it_behaves_like 'a found memory'
      end

      context 'and the memory is not approved' do
        context 'when there is no current user' do
          before :each do
            get :show, id: '123', format: format
          end

          it_behaves_like 'a not found memory'
        end

        context 'and the current user' do
          before :each do
            allow(controller).to receive(:current_user).and_return(user)
            allow(user).to receive(:can_modify?).and_return(can_modify)
            get :show, id: '123', format: format
          end

          context 'cannot modify the memory' do
            let(:can_modify) { false }

            it_behaves_like 'a not found memory'
          end

          context 'can modify the memory' do
            let(:can_modify) { true }

            it_behaves_like 'a found memory'
          end
        end
      end
    end

    context "when record is not found" do
      before :each do
        allow(Memory).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
        get :show, id: '123', format: format
      end

      it_behaves_like 'a not found memory'
    end
  end
end
