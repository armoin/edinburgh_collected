require 'rails_helper'

describe ScrapbooksController do
  describe 'GET index' do
    let(:scrapbooks)          { double('scrapbooks') }
    let(:ordered_scrapbooks)  { Array.new(2).map{|s| Fabricate.build(:scrapbook)} }
    let(:stub_presenter)      { double('presenter') }
    let(:stub_memory_fetcher) { double('approved_memory_fetcher') }

    before :each do
      allow(Scrapbook).to receive(:publicly_visible).and_return(scrapbooks)
      allow(scrapbooks).to receive(:by_last_created).and_return(ordered_scrapbooks)
      allow(ScrapbookIndexPresenter).to receive(:new).and_return(stub_presenter)
      allow(ApprovedScrapbookMemoryFetcher).to receive(:new).with(ordered_scrapbooks).and_return(stub_memory_fetcher)
      get :index
    end

    it 'stores the scrapbook index path' do
      expect(session[:current_scrapbook_index_path]).to eql(scrapbooks_path)
    end

    it 'does not set the current memory index path' do
      expect(session[:current_memory_index_path]).to be_nil
    end

    it 'fetches all publicly_visible scrapbooks' do
      expect(Scrapbook).to have_received(:publicly_visible)
    end

    it 'orders the scrapbooks by most recently created' do
      expect(scrapbooks).to have_received(:by_last_created)
    end

    it "generates a ScrapbookIndexPresenter for the scrapbooks" do
      expect(ScrapbookIndexPresenter).to have_received(:new).with(ordered_scrapbooks, stub_memory_fetcher, nil)
    end

    it "assigns the generated presenter" do
      expect(assigns[:presenter]).to eql(stub_presenter)
    end

    it 'renders the index page' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    let(:scrapbook)          { Fabricate.build(:scrapbook, id: 123) }
    let(:visible_scrapbooks) { double('visible scrapbooks') }
    let(:memories)           { double('scrapbook memories') }
    let(:paginated_memories) { double('paginated memories') }

    before :each do
      allow(Scrapbook).to receive(:publicly_visible).and_return(visible_scrapbooks)
      allow(visible_scrapbooks).to receive(:find).and_return(scrapbook)
      allow(scrapbook).to receive(:approved_ordered_memories).and_return(memories)
      allow(Kaminari).to receive(:paginate_array).and_return(paginated_memories)
      allow(paginated_memories).to receive(:page).and_return(paginated_memories)
      get :show, id: scrapbook.id
    end

    it 'does not store the scrapbook index path' do
      expect(session[:current_scrapbook_index_path]).to be_nil
    end

    it 'sets the current memory index path' do
      expect(session[:current_memory_index_path]).to eql(scrapbook_path(scrapbook.id))
    end

    it 'fetches the requested scrapbook' do
      expect(visible_scrapbooks).to have_received(:find).with(scrapbook.to_param)
    end

    context "when the scrapbook is found" do
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
      before :each do
        allow(visible_scrapbooks).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
        get :show, id: scrapbook.id
      end

      it 'renders the Not Found page' do
        expect(response).to render_template('exceptions/not_found')
      end

      it 'has a 404 status' do
        expect(response.status).to eql(404)
      end
    end
  end
end
