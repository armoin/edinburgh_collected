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

  describe 'GET show' do
    let(:scrapbook)          { Fabricate.build(:scrapbook, id: 123) }
    let(:query)              { 'test string' }
    let(:visible_scrapbooks) { double('visible scrapbooks') }
    let(:find_result)        { scrapbook }
    let(:memories)           { double('scrapbook memories') }
    let(:paginated_memories) { double('paginated memories') }

    before :each do
      allow(Scrapbook).to receive(:publicly_visible).and_return(visible_scrapbooks)
      allow(visible_scrapbooks).to receive(:find) { find_result }
      allow(scrapbook).to receive(:approved_ordered_memories).and_return(memories)
      allow(Kaminari).to receive(:paginate_array).and_return(paginated_memories)
      allow(paginated_memories).to receive(:page).and_return(paginated_memories)
      get :show, id: scrapbook.id, query: query
    end

    it 'does not store the scrapbook index path' do
      expect(session[:current_scrapbook_index_path]).to be_nil
    end

    it 'sets the current memory index path' do
      expect(session[:current_memory_index_path]).to eql(search_scrapbook_path(scrapbook.id, query: query))
    end

    it 'fetches the requested scrapbook' do
      expect(visible_scrapbooks).to have_received(:find).with(scrapbook.to_param)
    end

    context "when the scrapbook is found" do
      let(:find_result) { scrapbook }

      it "assigns the scrapbook" do
        expect(assigns[:scrapbook]).to eql(scrapbook)
      end

      it "fetches the scrapbook's approved memories in the correct order" do
        expect(scrapbook).to have_received(:approved_ordered_memories)
      end

      it "paginates the memories" do
        expect(Kaminari).to have_received(:paginate_array).with(memories)
        expect(paginated_memories).to have_received(:page)
      end

      it "assigns the paginated memories" do
        expect(assigns[:memories]).to eql(paginated_memories)
      end

      it 'renders the show page' do
        expect(response).to render_template(:show)
      end

      it 'has a 200 status' do
        expect(response.status).to eql(200)
      end
    end

    context "when the scrapbook is not found" do
      let(:find_result) { fail ActiveRecord::RecordNotFound }

      it 'renders the Not Found page' do
        expect(response).to render_template('exceptions/not_found')
      end

      it 'has a 404 status' do
        expect(response.status).to eql(404)
      end
    end
  end
end

