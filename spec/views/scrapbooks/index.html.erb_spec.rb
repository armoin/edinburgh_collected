require 'rails_helper'

describe 'scrapbooks/index.html.erb' do
  let(:scrapbooks) { Array.new(3) { Fabricate.build(:scrapbook) } }
  let(:memory)     { Fabricate.build(:photo_memory) }

  before :each do
    allow_any_instance_of(Scrapbook).to receive(:cover_memory).and_return(memory)
  end

  describe 'toggle to switch to the memories list' do
    before :each do
      assign(:scrapbooks, scrapbooks)
      render
    end

    it 'displays Memories as not active' do
      expect(rendered).to have_css('.nav.nav-pills li a[href="/memories"]')
      expect(rendered).not_to have_css('.nav.nav-pills li.active a[href="/memories"]')
    end

    it 'displays Scrapbooks as active' do
      expect(rendered).to have_css('.nav.nav-pills li.active a[href="/scrapbooks"]')
    end
  end

  it_behaves_like 'a scrapbook index'
end
