require 'rails_helper'

describe HomeController do
  before :each do
    get :index
  end

  it 'sets the current memory index path' do
    expect(session[:current_memory_index_path]).to eql(root_path)
  end

  it 'sets the current scrapbook index path' do
    expect(session[:current_scrapbook_index_path]).to eql(root_path)
  end

  it 'renders the home page' do
    expect(response).to render_template(:index)
  end
end