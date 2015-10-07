require 'rails_helper'

describe "my/scrapbooks/show.html.erb" do
  describe "action bar" do
    let(:owner)          { Fabricate.build(:user, id: 123) }
    let(:scrapbook)      { Fabricate.build(:scrapbook, id: 456, user: owner) }
    let(:memories)       { [] }
    let(:paged_memories) { Kaminari.paginate_array(memories).page(1) }

    before :each do
      assign(:scrapbook, scrapbook)
      assign(:memories, paged_memories)

      allow(view).to receive(:current_user).and_return(owner)

      render
    end

    it "has a button to the my scrapbook index page" do
      expect(rendered).to have_link('All my scrapbooks', href: my_scrapbooks_path)
    end

    it "has an edit link" do
      expect(rendered).to have_link('Edit', href: edit_my_scrapbook_path(scrapbook))
    end

    it "has a delete link" do
      expect(rendered).to have_link('Delete', href: my_scrapbook_path(scrapbook))
    end

    context "and the scrapbook has no memories" do
      let(:memories) { [] }

      it "has an 'Add more memories' link but it is hidden" do
        expect(rendered).to have_css('.no-memories a', text: 'Add more memories')
      end
    end

    context "and the scrapbook has memories" do
      let(:memories) { [Fabricate.build(:memory, id: 123)] }

      it "has an 'Add more memories' link" do
        expect(rendered).to have_link('Add more memories')
      end
    end
  end

  it_behaves_like 'a scrapbook page'
end
