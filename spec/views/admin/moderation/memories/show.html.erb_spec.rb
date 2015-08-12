require 'rails_helper'

describe 'admin/moderation/memories/show.html.erb' do
  describe 'moderation actions' do
    let(:user)         { Fabricate.build(:admin_user, id: 456) }
    let(:reason)       { nil }
    let(:list_path)    { 'test/path' }
    let(:moderatable)  { Fabricate.build(:memory, id: 123, user: user, moderation_state: state, moderation_reason: reason) }
    let(:path_segment) { 'memory' }

    before :each do
      assign(:memory, moderatable)
      allow(view).to receive(:current_memory_index_path).and_return(list_path)
      render
    end

    it_behaves_like 'a moderated show page'
  end

  describe "action bar" do
    let(:user)   { Fabricate.build(:active_user, id: 123) }
    let(:memory) { Fabricate.build(:photo_memory, id: 456, user: user) }

    before :each do
      assign(:memory, memory)
      render
    end

    it 'has a back button to "More memories from this user"' do
      expect(rendered).to have_link('More memories from this user', href: user_memories_path(user))
    end
  end

  it_behaves_like 'a memory page'
end
