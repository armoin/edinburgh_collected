require 'rails_helper'

describe 'report/scrapbooks/edit.html.erb' do
  let(:scrapbook) { Fabricate(:scrapbook) }

  before :each do
    assign(:scrapbook, scrapbook)
    render
  end

  it 'gives the user some important information' do
    expect(rendered).to have_css('#infoPanel')
  end

  it 'has a moderation reason input' do
    expect(rendered).to have_css('#report-concern textarea#scrapbook_moderation_reason')
  end

  it "allows the user to submit the form" do
    expect(rendered).to have_css('#report-concern input[type="submit"]')
  end

  it "allows the user to cancel back to the scrapbook page" do
    expect(rendered).to have_link('Cancel', href: scrapbook_path(scrapbook))
  end
end