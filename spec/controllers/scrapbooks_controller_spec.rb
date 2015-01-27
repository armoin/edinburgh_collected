require 'rails_helper'

describe ScrapbooksController do
  describe 'GET index' do
    let(:num_scrapbooks) { 2 }
    let(:scrapbooks)     { Array.new(num_scrapbooks).map.with_index{|s,i| Fabricate.build(:scrapbook, id: i+1)} }
  
    before :each do
      allow(Scrapbook).to receive(:approved).and_return(scrapbooks)
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

    it "provides the results" do
      expect(assigns[:scrapbooks].length).to eql(num_scrapbooks)
    end

    it "wraps the results in a ScrapbookCoverPresenter" do
      assigns[:scrapbooks].each do |scrapbook|
        expect(scrapbook).to be_a(ScrapbookCoverPresenter)
      end
    end

    it "paginates the results" do
      expect(assigns[:scrapbooks]).to respond_to(:current_page)
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
