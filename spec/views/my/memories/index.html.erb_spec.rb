require 'rails_helper'

describe 'my/memories/index.html.erb' do
  let(:user)     { Fabricate(:user) }
  let(:memories) { Fabricate.times(3, :photo_memory, user: user) }

  before :each do
    assign(:memories, memories)
    render
  end

  describe 'toggle to switch to the scrapbooks list' do
    it 'displays Memories as active' do
      expect(rendered).to have_css('.nav.nav-pills li.active a[href="/my/memories"]')
    end

    it 'displays Scrapbooks as not active' do
      expect(rendered).to have_css('.nav.nav-pills li a[href="/my/scrapbooks"]')
      expect(rendered).not_to have_css('.nav.nav-pills li.active a[href="/my/scrapbooks"]')
    end
  end

  context 'a memory' do
    let(:memory) { memories.first }

    it 'is a link to the show page for that memory' do
      expect(rendered).to have_css("a.memory[href=\"#{my_memory_path(memory)}\"]")
    end
  end

  it_behaves_like 'a memory index'
end


