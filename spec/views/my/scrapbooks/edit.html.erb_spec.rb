require 'rails_helper'

describe 'my/scrapbooks/edit.html.erb' do
  let(:scrapbook)           { Fabricate.build(:scrapbook, id: 132) }
  let(:memories)            { stub_memories(3).map.with_index{|m,i| double(id: i, scrapbook: scrapbook, memory: m)} }
  let(:scrapbook_memories)  { double('scrapbook_memories', by_ordering: memories) }

  before :each do
    allow(scrapbook).to receive(:scrapbook_memories).and_return(scrapbook_memories)
    assign(:scrapbook, scrapbook)
    render
  end

  it "has an 'All my scrapbooks' link to the my_scrapbooks page" do
    render
    expect(rendered).to have_link('All my scrapbooks', href: my_scrapbooks_path)
  end

  context "when scrapbook doesn't belong to the user" do
    before :each do
      allow(view).to receive(:belongs_to_user?).and_return(false)
      render
    end

    it "does not have an 'Add more memories' link" do
      expect(rendered).not_to have_link('Add more memories', href: memories_path)
    end

    it "does not have a show link" do
      expect(rendered).not_to have_link('Show', href: my_scrapbook_path(scrapbook))
    end

    it "does not have a delete link" do
      expect(rendered).not_to have_link('Delete', href: my_scrapbook_path(scrapbook))
    end
  end

  context "when scrapbook belongs to the user" do
    before :each do
      allow(view).to receive(:belongs_to_user?).and_return(true)
      render
    end

    it "has an 'Add more memories' link" do
      expect(rendered).to have_link('Add more memories', href: memories_path)
    end

    it "has a show link" do
      expect(rendered).to have_link('Show', href: my_scrapbook_path(scrapbook))
    end

    it "has a delete link" do
      expect(rendered).to have_link('Delete', href: my_scrapbook_path(scrapbook))
    end
  end

  describe 'editing the scrapbook details' do
    it 'lets the user edit the title' do
      expect(rendered).to have_css('input#scrapbook_title', count: 1)
    end

    it 'lets the user edit the description' do
      expect(rendered).to have_css('textarea#scrapbook_description', count: 1)
    end
  end

  describe "the scrapbook's memories" do
    it "displays all of the scrapbook's memories" do
      expect(rendered).to have_css('.memory', count: 3)
    end

    it "lets the user delete a memory" do
      expect(rendered).to have_css(".memory a[data-method='delete']", text: 'Delete', count: 3)
    end
  end
end
