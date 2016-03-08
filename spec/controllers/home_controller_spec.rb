require 'rails_helper'

describe HomeController do
  let(:home_page)           { double('home page') }
  let(:home_page_presenter) { double('home page presenter') }

  before :each do
    allow(HomePage).to receive(:current).and_return(home_page)
    allow(HomePagePresenter).to receive(:new).and_return(home_page_presenter)
    get :index
  end

  it 'sets the current memory index path' do
    expect(session[:current_memory_index_path]).to eql(root_path)
  end

  it 'sets the current scrapbook index path' do
    expect(session[:current_scrapbook_index_path]).to eql(root_path)
  end

  it 'assigns a HomePagePresenter' do
    expect(HomePagePresenter).to have_received(:new).with(home_page)
    expect(assigns[:home_page_presenter]).to eq(home_page_presenter)
  end

  it 'renders the home page' do
    expect(response).to render_template(:index)
  end
end
