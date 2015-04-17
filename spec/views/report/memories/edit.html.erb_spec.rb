require 'rails_helper'

describe 'report/memories/edit.html.erb' do
  let(:memory) { Fabricate(:memory) }

  before :each do
    assign(:memory, memory)
    render
  end

  it 'gives the user some important information' do
    expect(rendered).to have_css('#infoPanel')
  end

  it 'has a moderation reason input' do
    expect(rendered).to have_css('#report-concern textarea#memory_moderation_reason')
  end

  it "allows the user to submit the form" do
    expect(rendered).to have_css('#report-concern input[type="submit"]')
  end

  it "allows the user to cancel back to the memory page" do
    expect(rendered).to have_link('Cancel', href: memory_path(memory))
  end
end