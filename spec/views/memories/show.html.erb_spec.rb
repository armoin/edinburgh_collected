require 'rails_helper'

describe "memories/show.html.erb" do
  describe "action bar" do
    let(:user)   { Fabricate.build(:active_user, id: 123) }
    let(:memory) { Fabricate.build(:photo_memory, id: 456, user: user) }
    let(:page)   { '2' }

    before :each do
      assign(:memory, memory)
      assign(:page, page)
      render
    end

    it "has a back button to all memories including the page number" do
      expect(rendered).to have_link('Back', href: memories_path(page: page))
    end
  end

  it_behaves_like 'a memory page'
end
