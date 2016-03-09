require 'rails_helper'

RSpec.describe 'admin/cms/home_pages/new.html.erb' do
  before :each do
    assign(:home_page, HomePage.new)
    render
  end

  it 'has a form title' do
    expect(rendered).to have_css('h1.form-title', text: 'New home page')
  end

  it 'has a form that creates a new home page' do
    expect(rendered).to have_css("form[method='post'][action='#{admin_cms_home_pages_path}']")
  end

  it 'has a featured memory id text field' do
    expect(rendered).to have_css('input#home_page_featured_memory_id[type="text"]')
  end

  it 'has a featured scrapbook id text field' do
    expect(rendered).to have_css('input#home_page_featured_scrapbook_id[type="text"]')
  end

  it 'has a submit button' do
    expect(rendered).to have_css('input[type="submit"]')
  end

  it 'has a cancel link' do
    expect(rendered).to have_link('Cancel', href: admin_cms_home_pages_path)
  end
end
