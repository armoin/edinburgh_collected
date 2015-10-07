require 'rails_helper'

describe "users/scrapbooks/show.html.erb" do
  let(:requested_user) { Fabricate.build(:user, id: 123) }
  let(:scrapbook)      { Fabricate.build(:scrapbook, id: 456, user: requested_user) }
  let(:memories)       { [] }
  let(:paged_memories) { Kaminari.paginate_array(memories).page(1) }

  before :each do
    assign(:scrapbook, scrapbook)
    assign(:memories, paged_memories)
    assign(:requested_user, requested_user)
  end

  describe "action bar" do
    before :each do
      render
    end

    it "has a button to the users scrapbook index page" do
      expect(rendered).to have_link('More scrapbooks from this user', href: user_scrapbooks_path(requested_user))
    end

    it "does not have an edit link" do
      expect(rendered).not_to have_link('Edit')
    end

    it "does not have a delete link" do
      expect(rendered).not_to have_link('Delete')
    end

    it "does not have an 'Add more memories' link" do
      expect(rendered).not_to have_link('Add more memories')
    end
  end

  it_behaves_like 'a scrapbook page'
end
