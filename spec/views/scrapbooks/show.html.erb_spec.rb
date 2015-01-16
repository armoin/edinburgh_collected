require 'rails_helper'

describe "scrapbooks/show.html.erb" do
  let(:scrapbook) { Fabricate.build(:scrapbook, id: 123) }
  let(:user)      { Fabricate.build(:active_user) }

  before :each do
    allow(view).to receive(:current_user).and_return(user)
    assign(:scrapbook, scrapbook)
  end

  context "when scrapbook doesn't belong to the user" do
    before :each do
      allow(user).to receive(:can_modify?).and_return(false)
      render
    end

    it "does not have an edit link" do
      expect(rendered).not_to have_link('Edit', href: edit_my_scrapbook_path(scrapbook))
    end

    it "does not have a delete link" do
      expect(rendered).not_to have_link('Delete', href: my_scrapbook_path(scrapbook))
    end
  end

  context "when scrapbook belongs to the user" do
    before :each do
      allow(user).to receive(:can_modify?).and_return(true)
    end

    context "and the scrapbook has no memories" do
      before :each do
        allow(scrapbook).to receive(:ordered_memories).and_return([])
      end

      it "does not have an 'Add memories' link" do
        render
        expect(rendered).not_to have_link('Add memories')
      end
    end

    context "and the scrapbook has memories" do
      before :each do
        allow(scrapbook).to receive(:ordered_memories).and_return([Fabricate.build(:memory, id: 123)])
      end

      it "has an 'Add memories' link" do
        render
        expect(rendered).to have_link('Add memories')
      end
    end

    it "has an edit link" do
      render
      expect(rendered).to have_link('Edit', href: edit_my_scrapbook_path(scrapbook))
    end

    it "has a delete link" do
      render
      expect(rendered).to have_link('Delete', href: my_scrapbook_path(scrapbook))
    end
  end

  describe "scrapbook details" do
    before :each do
      render
    end

    it "has a title" do
      expect(rendered).to have_content(scrapbook.title)
    end

    it "has a description" do
      expect(rendered).to have_content(scrapbook.description)
    end
  end

  describe "memory thumbnails" do
    let(:memories)            { stub_memories(3).map.with_index{|m,i| double(id: i, scrapbook: scrapbook, memory: m)} }
    let(:scrapbook_memories)  { double('scrapbook_memories', by_ordering: memories) }

    before :each do
      allow(scrapbook).to receive(:scrapbook_memories).and_return(scrapbook_memories)
      render
    end

    it "displays one for each memory" do
      expect(rendered).to have_css('.memory', count: 3)
    end

    it "displays the memory's image" do
      expect(rendered).to match /1\.jpg/
      expect(rendered).to match /2\.jpg/
      expect(rendered).to match /3\.jpg/
    end

    it "displays the memory's title" do
      expect(rendered).to match /Test 1/
      expect(rendered).to match /Test 2/
      expect(rendered).to match /Test 3/
    end
  end
end

