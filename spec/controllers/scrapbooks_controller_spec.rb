require 'rails_helper'

describe ScrapbooksController do
  describe 'GET index' do
    let(:scrapbooks) { double('scrapbooks') }

    before :each do
      allow(Scrapbook).to receive(:all).and_return(scrapbooks)
      allow(scrapbooks).to receive(:page).and_return(scrapbooks)
      allow(scrapbooks).to receive(:per).and_return(scrapbooks)
      get :index
    end

    it 'stores the scrapbook index path' do
      expect(session[:current_scrapbook_index_path]).to eql(scrapbooks_path)
    end

    it 'does not set the current memory index path' do
      expect(session[:current_memory_index_path]).to be_nil
    end

    it 'fetches all scrapbooks' do
      expect(Scrapbook).to have_received(:all)
    end

    it "paginates the results" do
      expect(scrapbooks).to have_received(:page)
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
