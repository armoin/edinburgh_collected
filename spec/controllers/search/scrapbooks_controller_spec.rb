require 'rails_helper'

describe Search::ScrapbooksController do
  let(:approved_scrapbooks) { double('approved_scrapbooks') }
  let(:returned_scrapbooks) { double('returned_scrapbooks') }
  let(:format)              { :html }

  before(:each) do
    allow(Scrapbook).to receive(:approved).and_return(approved_scrapbooks)
  end

  describe 'GET index' do
    before(:each) do
      allow(approved_scrapbooks).to receive(:text_search).with(query).and_return(returned_scrapbooks)
      allow(returned_scrapbooks).to receive(:page).and_return(returned_scrapbooks)
      allow(returned_scrapbooks).to receive(:per).and_return(returned_scrapbooks)
      get :index, format: format, query: query
    end

    context 'when no query is given' do
      let(:query) { nil }

      it 'stores the scrapbook index path with no query' do
        expect(session[:current_scrapbook_index_path]).to eql(search_scrapbooks_path(format: format))
      end

      it "redirects to the browse scrapbooks page" do
        expect(response).to redirect_to(scrapbooks_path)
      end
    end

    context 'when a blank query is given' do
      let(:query) { "" }

      it 'stores the scrapbook index path with an empty query' do
        expect(session[:current_scrapbook_index_path]).to eql(search_scrapbooks_path(format: format, query: query))
      end

      it "redirects to the browse scrapbooks page" do
        expect(response).to redirect_to(scrapbooks_path)
      end
    end

    context 'when a query is given' do
      let(:query) { "test search" }

      it 'stores the scrapbook index path with the given query' do
        expect(session[:current_scrapbook_index_path]).to eql(search_scrapbooks_path(format: format, query: query))
      end

      it "fetches the approved scrapbooks" do
        expect(Scrapbook).to have_received(:approved)
      end

      it "searches for the given query" do
        expect(approved_scrapbooks).to have_received(:text_search).with(query)
      end

      it "paginates the results 30 to a page" do
        expect(returned_scrapbooks).to have_received(:page)
        expect(returned_scrapbooks).to have_received(:per).with(30)
      end

      it "assigns the returned scrapbooks" do
        expect(assigns(:scrapbooks)).to eql(returned_scrapbooks)
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

