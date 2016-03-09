require 'rails_helper'

RSpec.describe 'admin/cms/home_pages/edit.html.erb' do
  before :all do
    @memory = Fabricate(:approved_photo_memory)
    @scrapbook = Fabricate(:approved_scrapbook)
  end

  after :all do
    @memory.destroy
    @scrapbook.destroy
    User.destroy_all
  end

  let(:home_page) do
    HomePage.new(
      featured_memory: @memory,
      featured_scrapbook: @scrapbook
    )
  end

  before :each do
    assign(:home_page_presenter, HomePagePresenter.new(home_page))
    render
  end

  it 'has a title' do
    expect(rendered).to have_css('h1', text: 'Edit home page')
  end
end
