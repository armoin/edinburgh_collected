require 'rails_helper'

describe 'my/scrapbooks/edit.html.erb' do
  let(:scrapbook)           { Fabricate.build(:scrapbook, id: 132) }
  let(:memories)            { stub_memories(3).map.with_index{|m,i| double(id: i, scrapbook: scrapbook, memory: m)} }
  let(:scrapbook_memories)  { double('scrapbook_memories', by_ordering: memories) }

  before :each do
    allow(scrapbook).to receive(:scrapbook_memories).and_return(scrapbook_memories)
    assign(:scrapbook, scrapbook)
  end

  describe 'editing the scrapbook details' do
    before :each do
      render
    end

    it 'lets the user edit the title' do
      expect(rendered).to have_css('input#scrapbook_title', count: 1)
    end

    it 'lets the user edit the description' do
      expect(rendered).to have_css('textarea#scrapbook_description', count: 1)
    end

    it "lets the user cancel the edit" do
      expect(rendered).to have_link('Cancel', href: my_scrapbook_path(scrapbook))
    end

    it "lets the user save the edit" do
      expect(rendered).to have_css('input[type="submit"][value="Save changes"]')
    end
  end

  describe "the scrapbook's memories" do
    before :each do
      render
    end

    it "displays all of the scrapbook's memories" do
      expect(rendered).to have_css('.memory', count: 3)
    end

    it "lets the user remove a memory" do
      expect(rendered).to have_css(".memory button.remove-memory", text: 'Remove', count: 3)
    end
  end
end
