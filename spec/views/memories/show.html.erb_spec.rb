require 'rails_helper'

describe "memories/show.html.erb" do
  describe "action bar" do
    let(:user)   { Fabricate.build(:active_user, id: 123) }
    let(:memory) { Fabricate.build(:photo_memory, id: 456, user: user) }

    before :each do
      assign(:memory, memory)
      render
    end

    it 'has a back button to "All memories"' do
      expect(rendered).to have_link('All memories', href: memories_path)
    end
  end

  it_behaves_like 'a memory page'
end
