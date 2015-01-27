require 'rails_helper'

describe Search::MemoriesController do
  let(:format)               { :html }
  let(:paged_memory_results) { double('paged_memory_results') }
  let(:memory_results)       { double('memory_results', page: paged_memory_results) }
  let(:results)              { double('results', memory_results: memory_results) }

  before(:each) do
    allow(SearchResults).to receive(:new).and_return(results)
  end

  describe 'GET index' do
    context 'when no query is given' do
      before(:each) do
        get :index, format: format, query: nil
      end

      it 'stores the memory index path with no query' do
        expect(session[:current_memory_index_path]).to eql(search_memories_path(format: format))
      end

      it "redirects to the browse memories page" do
        expect(response).to redirect_to(memories_path)
      end

      it "doesn't generate search results" do
        expect(SearchResults).not_to receive(:new)
      end
    end

    context 'when a blank query is given' do
      before(:each) do
        get :index, format: format, query: ''
      end

      it 'stores the memory index path with an empty query' do
        expect(session[:current_memory_index_path]).to eql(search_memories_path(format: format, query: ''))
      end

      it "redirects to the browse memories page" do
        expect(response).to redirect_to(memories_path)
      end

      it "doesn't generate search results" do
        expect(SearchResults).not_to receive(:new)
      end
    end

    context 'when a query is given' do
      let(:query)   { "test search" }

      context 'when no page number is given' do
        before :each do
          get :index, format: format, query: query
        end

        it 'stores the memory index path with the given query' do
          expect(session[:current_memory_index_path]).to eql(search_memories_path(format: format, query: query))
        end

        it 'generates search results for the given query' do
          expect(SearchResults).to have_received(:new).with(query)
        end

        it "assigns the returned results" do
          expect(assigns(:results)).to eql(results)
        end

        it "paginates the results" do
          expect(memory_results).to have_received(:page).with(nil)
        end

        it "assigns the paged memory results" do
          expect(assigns(:memories)).to eql(paged_memory_results)
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

      context 'when a page number is given' do
        let(:page) { '2' }

        before :each do
          get :index, format: format, query: query, page: page
        end

        it 'stores the memory index path with the given query and page' do
          expected = search_memories_path(format: format, query: query, page: page)
          expect(session[:current_memory_index_path]).to eql(expected)
        end

        it 'generates search results for the given query' do
          expect(SearchResults).to have_received(:new).with(query)
        end

        it "assigns the returned results" do
          expect(assigns(:results)).to eql(results)
        end

        it "paginates the results" do
          expect(memory_results).to have_received(:page).with(page)
        end

        it "assigns the paged memory results" do
          expect(assigns(:memories)).to eql(paged_memory_results)
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
end

