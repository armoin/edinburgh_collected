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

  describe 'GET show' do
    let(:user)        { Fabricate.build(:user) }
    let(:memory)      { Fabricate.build(:memory) }
    let(:find_result) { memory }
    let(:visible)     { false }
    let(:can_modify)  { false }

    before :each do
      allow(Memory).to receive(:find) { find_result }

      allow(memory).to receive(:publicly_visible?).and_return(visible)
      allow(controller).to receive(:current_user).and_return(user)
      allow(user).to receive(:can_modify?).and_return(can_modify)

      get :show, id: '123', format: format, query: 'test query'
    end

    it 'does not set the current memory index path' do
      expect(session[:current_memory_index_path]).to be_nil
    end

    it "fetches the requested memory" do
      expect(Memory).to have_received(:find).with('123')
    end

    context "when record is found" do
      let(:find_result) { memory }

      it "assigns fetched memory" do
        expect(assigns(:memory)).to eql(memory)
      end

      context 'and memory is visible' do
        let(:visible) { true }

        it 'assigns the current query string' do
          expect(assigns[:query]).to eql('test query')
        end

        it_behaves_like 'a found memory'
      end

      context 'and the memory is not visible' do
        let(:visible) { false }

        context 'when there is no current user' do
          it 'does not assign the current query string' do
            expect(assigns[:query]).to be_nil
          end

          it_behaves_like 'a not found memory'
        end

        context 'and the current user' do
          context 'cannot modify the memory' do
            let(:can_modify) { false }

            it 'does not assign the current query string' do
              expect(assigns[:query]).to be_nil
            end

            it_behaves_like 'a not found memory'
          end

          context 'can modify the memory' do
            let(:can_modify) { true }

            it 'assigns the current query string' do
              expect(assigns[:query]).to eql('test query')
            end

            it_behaves_like 'a found memory'
          end
        end
      end
    end

    context "when record is not found" do
      let(:find_result) { raise ActiveRecord::RecordNotFound }

      it_behaves_like 'a not found memory'
    end
  end
end

