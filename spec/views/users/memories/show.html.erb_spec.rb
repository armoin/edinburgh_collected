require 'rails_helper'

describe "users/memories/show.html.erb" do
  describe "action bar" do
    let(:user)   { Fabricate.build(:active_user, id: 123)}
    let(:memory) { Fabricate.build(:photo_memory, id: 456, user: user) }

    before :each do
      assign(:memory, memory)
      render
    end

    it 'has a button to the "More memories from this user" index page' do
      expect(rendered).to have_link('More memories from this user', href: user_memories_path(user))
    end
  end

  it_behaves_like 'a memory page'
end
