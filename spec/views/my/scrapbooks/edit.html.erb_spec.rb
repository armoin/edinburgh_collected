require 'rails_helper'

describe 'my/scrapbooks/edit.html.erb' do
  let(:scrapbook)           { Fabricate.build(:scrapbook, id: 132) }
  let(:scrapbook_memories)  { Array.new(3) {|i| Fabricate.build(:scrapbook_memory)} }

  before :each do
    allow(scrapbook).to receive(:approved_or_owned_scrapbook_memories).and_return(scrapbook_memories)
    assign(:scrapbook, scrapbook)
  end

  describe 'header' do
    before :each do
      render
    end

    it 'displays the title of the scrapbook being edited' do
      expect(rendered).to have_css('h1', text: "Editing #{scrapbook.title}")
    end
  end

  describe 'action bar' do
    before :each do
      render
    end

    it "lets the user go back to the scrapbook page" do
      expect(rendered).to have_link('Cancel', href: my_scrapbook_path(scrapbook))
    end

    it "lets the user save the edit" do
      expect(rendered).to have_link('Save changes')
    end
  end

  describe 'editing the scrapbook details' do
    before :each do
      render
    end

    it 'lets the user edit the title' do
      expect(rendered).to have_css('#edit-scrapbook input#scrapbook_title', count: 1)
    end

    it 'lets the user edit the description' do
      expect(rendered).to have_css('#edit-scrapbook textarea#scrapbook_description', count: 1)
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
