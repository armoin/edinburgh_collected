require 'rails_helper'

RSpec.describe 'admin/cms/home_pages/edit.html.erb' do
  include_context 'home_page'

  let(:home_page) do
    HomePage.create!(
      featured_memory:    @featured_memory,
      featured_scrapbook: @featured_scrapbook
    )
  end

  before :each do
    assign(:home_page, home_page)
    render
  end

  it 'has a title' do
    expect(rendered).to have_css('h1', text: 'Edit home page')
  end

  it 'has an edit form' do
    expect(rendered).to have_css("form[action='#{admin_cms_home_page_path(home_page)}']")
  end

  it 'has an image_editor for the hero_image that uses guillotine' do
    expect(rendered).to have_css('#image-editor.hero.guillotine')
  end

  it 'has a submit button' do
    expect(rendered).to have_css('input[type="submit"][value="Save changes"]')
  end

  it 'has a cancel link' do
    expect(rendered).to have_link('Cancel', href: admin_cms_home_page_path(home_page))
  end
end
