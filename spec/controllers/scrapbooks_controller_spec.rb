require 'rails_helper'

describe ScrapbooksController do
  describe 'GET index' do
    before :each do
      allow(Scrapbook).to receive(:all)
      get :index
    end

    it 'does not set the current memory index path' do
      expect(session[:current_memory_index_path]).to be_nil
    end

    it 'fetches all scrapbooks' do
      expect(Scrapbook).to have_received(:all)
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
