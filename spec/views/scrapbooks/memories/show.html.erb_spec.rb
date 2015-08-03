require 'rails_helper'

describe "scrapbooks/memories/show.html.erb" do
  let(:scrapbook) { Fabricate.build(:scrapbook, id: 789) }

  before :each do
    assign(:scrapbook, scrapbook)
  end
  describe "action bar" do
    let(:user)   { Fabricate.build(:active_user, id: 123) }
    let(:memory) { Fabricate.build(:photo_memory, id: 456, user: user) }

    before :each do
      assign(:memory, memory)
      assign(:page, '2')
      render
    end

    it "has a back button to the scrapbook page including the page number" do
      expect(rendered).to have_link('Back', href: scrapbook_path(scrapbook, page: '2'))
    end
  end

  it_behaves_like 'a memory page'
end
