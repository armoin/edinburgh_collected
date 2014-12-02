require 'rails_helper'

describe Search::MemoriesController do
  let(:approved_memories) { double('approved_memories') }
  let(:returned_memories) { double('returned_memories') }
  let(:format)            { :html }

  before(:each) do
    allow(Memory).to receive(:approved).and_return(approved_memories)
  end

  describe 'GET index' do
    before(:each) do
      allow(approved_memories).to receive(:text_search).with(query).and_return(returned_memories)
      allow(returned_memories).to receive(:page).and_return(returned_memories)
      allow(returned_memories).to receive(:per).and_return(returned_memories)
      get :index, format: format, query: query
    end

    context 'when no query is given' do
      let(:query) { nil }

      it "redirects to the browse memories page" do
        expect(response).to redirect_to(memories_path)
      end
    end

    context 'when a blank query is given' do
      let(:query) { "" }

      it "redirects to the browse memories page" do
        expect(response).to redirect_to(memories_path)
      end
    end

    context 'when a query is given' do
      let(:query) { "test search" }

      it "fetches the approved memories" do
        expect(Memory).to have_received(:approved)
      end

      it "searches for the given query" do
        expect(approved_memories).to have_received(:text_search).with(query)
      end

      it "paginates the results 30 to a page" do
        expect(returned_memories).to have_received(:page)
        expect(returned_memories).to have_received(:per).with(30)
      end

      it "assigns the returned memories" do
        expect(assigns(:memories)).to eql(returned_memories)
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
    end
  end
end

