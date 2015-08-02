require 'rails_helper'

describe "memories/show.html.erb" do
  describe "action bar" do
    let(:user)   { Fabricate.build(:active_user, id: 123) }
    let(:memory) { Fabricate.build(:photo_memory, id: 456, user: user) }

    before :each do
      assign(:memory, memory)
      render
    end

    it "has a back button to the all memories index page" do
      expect(rendered).to have_link('Back', href: memories_path)
    end
  end

  it_behaves_like 'a memory page'
end
