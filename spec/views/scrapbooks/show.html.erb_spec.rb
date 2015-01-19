require 'rails_helper'

describe "scrapbooks/show.html.erb" do
  let(:scrapbook)  { Fabricate.build(:scrapbook, id: 123) }
  let(:user)       { Fabricate.build(:active_user) }
  let(:can_modify) { false }
  let(:memories)   { [] }

  before :each do
    allow(view).to receive(:current_user).and_return(user)
    allow(user).to receive(:can_modify?).and_return(can_modify)
    allow(scrapbook).to receive(:ordered_memories).and_return(memories)
    assign(:scrapbook, scrapbook)
    render
  end

  describe "action bar" do
    context "when scrapbook doesn't belong to the user" do
      let(:can_modify) { false }

      it "does not have an edit link" do
        expect(rendered).not_to have_link('Edit', href: edit_my_scrapbook_path(scrapbook))
      end

      it "does not have a delete link" do
        expect(rendered).not_to have_link('Delete', href: my_scrapbook_path(scrapbook))
      end
    end

    context "when scrapbook belongs to the user" do
      let(:can_modify) { true }

      it "has an edit link" do
        expect(rendered).to have_link('Edit', href: edit_my_scrapbook_path(scrapbook))
      end

      it "has a delete link" do
        expect(rendered).to have_link('Delete', href: my_scrapbook_path(scrapbook))
      end

      context "and the scrapbook has no memories" do
        let(:memories) { [] }

        it "does not have an 'Add memories' link" do
          expect(rendered).not_to have_link('Add memories')
        end
      end

      context "and the scrapbook has memories" do
        let(:memories) { [Fabricate.build(:memory, id: 123)] }

        it "has an 'Add memories' link" do
          render
          expect(rendered).to have_link('Add memories')
        end
      end
    end
  end

  describe "scrapbook details" do
    it "has a title" do
      expect(rendered).to have_content(scrapbook.title)
    end

    it "has a description" do
      expect(rendered).to have_content(scrapbook.description)
    end

    context 'when there are no memories' do
      let(:memories) { [] }

      context "when scrapbook doesn't belong to the user" do
        let(:can_modify) { false }

        it 'does not display the Add Memories instructions' do
          expect(rendered).not_to have_css('#scrapbookInstructions')
        end
      end

      context "when scrapbook belongs to the user" do
        let(:can_modify) { true }

        it 'displays the Add Memories instructions' do
          expect(rendered).to have_css('#scrapbookInstructions')
        end
      end
    end

    context 'when there are memories' do
      let(:memories) { stub_memories(3) }

      it "displays a thumbnail for each memory" do
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
end

