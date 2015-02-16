require 'rails_helper'

describe ScrapbooksController do
  describe 'GET index' do
    let(:scrapbooks)          { Array.new(2).map{|s| Fabricate.build(:scrapbook)} }
    let(:stub_presenter)      { double('presenter') }
    let(:stub_memory_fetcher) { double('approved_memory_fetcher') }
  
    before :each do
      allow(Scrapbook).to receive(:approved).and_return(scrapbooks)
      allow(ScrapbookIndexPresenter).to receive(:new).and_return(stub_presenter)
      allow(ApprovedScrapbookMemoryFetcher).to receive(:new).with(scrapbooks).and_return(stub_memory_fetcher)
      get :index
    end

    it 'stores the scrapbook index path' do
      expect(session[:current_scrapbook_index_path]).to eql(scrapbooks_path)
    end

    it 'does not set the current memory index path' do
      expect(session[:current_memory_index_path]).to be_nil
    end

    it 'fetches all approved scrapbooks' do
      expect(Scrapbook).to have_received(:approved)
    end

    it "generates a ScrapbookIndexPresenter for the scrapbooks" do
      expect(ScrapbookIndexPresenter).to have_received(:new).with(scrapbooks, stub_memory_fetcher, nil)
    end

    it "assigns the generated presenter" do
      expect(assigns[:presenter]).to eql(stub_presenter)
    end

    it 'renders the index page' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    let(:scrapbook) { Fabricate.build(:scrapbook, id: 123) }

    before :each do
      allow(Scrapbook).to receive(:find).and_return(scrapbook)
      get :show, id: scrapbook.id
    end

    it 'does not store the scrapbook index path' do
      expect(session[:current_scrapbook_index_path]).to be_nil
    end

    it 'sets the current memory index path' do
      expect(session[:current_memory_index_path]).to eql(scrapbook_path(scrapbook.id))
    end

    it 'fetches the requested scrapbook' do
      expect(Scrapbook).to have_received(:find).with(scrapbook.to_param)
    end

    it 'renders the show page' do
      expect(response).to render_template(:show)
    end
  end
end
