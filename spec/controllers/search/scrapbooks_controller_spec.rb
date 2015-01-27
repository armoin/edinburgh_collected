require 'rails_helper'

describe Search::ScrapbooksController do
  let(:format)            { :html }
  let(:num_scrapbooks)    { 2 }
  let(:scrapbook_results) { Array.new(num_scrapbooks).map.with_index{|s,i| Fabricate.build(:scrapbook, id: i+1)} }
  let(:results)           { double('results', scrapbook_results: scrapbook_results) }

  before(:each) do
    allow(SearchResults).to receive(:new).and_return(results)
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

      it "assigns the scrapbooks from the results" do
        expect(assigns[:scrapbooks].length).to eql(num_scrapbooks)
      end

      it "paginates the results" do
        expect(assigns[:scrapbooks]).to respond_to(:current_page)
      end

      it "wraps the results in a ScrapbookCoverPresenter" do
        assigns[:scrapbooks].each do |scrapbook|
          expect(scrapbook).to be_a(ScrapbookCoverPresenter)
        end
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

