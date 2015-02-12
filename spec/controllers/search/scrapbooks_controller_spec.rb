require 'rails_helper'

describe Search::ScrapbooksController do
  let(:format)              { :html }
  let(:scrapbook_results)   { Array.new(2).map{|s| Fabricate.build(:scrapbook)} }
  let(:results)             { double('results', scrapbook_results: scrapbook_results) }
  let(:stub_presenter)      { double('presenter') }
  let(:stub_memory_fetcher) { double('approved_memory_fetcher') }

  before(:each) do
    allow(SearchResults).to receive(:new).and_return(results)
    allow(ScrapbookIndexPresenter).to receive(:new).and_return(stub_presenter)
    allow(ApprovedScrapbookMemoryFetcher).to receive(:new).with(scrapbook_results).and_return(stub_memory_fetcher)
  end

  describe 'GET index' do
    context 'when no query is given' do
      before :each do
        get :index, format: format, query: nil
      end

      it 'stores the scrapbook index path with no query' do
        expect(session[:current_scrapbook_index_path]).to eql(search_scrapbooks_path(format: format))
      end

      it "redirects to the browse scrapbooks page" do
        expect(response).to redirect_to(scrapbooks_path)
      end

      it "doesn't generate search results" do
        expect(SearchResults).not_to receive(:new)
      end
    end

    context 'when a blank query is given' do
      before :each do
        get :index, format: format, query: ''
      end

      it 'stores the scrapbook index path with an empty query' do
        expect(session[:current_scrapbook_index_path]).to eql(search_scrapbooks_path(format: format, query: ''))
      end

      it "redirects to the browse scrapbooks page" do
        expect(response).to redirect_to(scrapbooks_path)
      end

      it "doesn't generate search results" do
        expect(SearchResults).not_to receive(:new)
      end
    end

    context 'when a query is given' do
      let(:query) { "test search" }

      before :each do
        get :index, format: format, query: query, page: 1
      end

      it 'stores the scrapbook index path with the given query' do
        expect(session[:current_scrapbook_index_path]).to eql(search_scrapbooks_path(format: format, query: query, page: 1))
      end

      it 'generates search results for the given query' do
        expect(SearchResults).to have_received(:new).with(query)
      end

      it "assigns the returned results" do
        expect(assigns(:results)).to eql(results)
      end

      it "generates a ScrapbookIndexPresenter for the found scrapbooks passing in the page" do
        expect(ScrapbookIndexPresenter).to have_received(:new).with(scrapbook_results, stub_memory_fetcher, '1')
      end

      it "assigns the generated presenter" do
        expect(assigns[:presenter]).to eql(stub_presenter)
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

