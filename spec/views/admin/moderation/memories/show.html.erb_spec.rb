require 'rails_helper'

describe 'admin/moderation/memories/show.html.erb' do
  let(:memory)      { Fabricate.build(:photo_memory, id: 123) }
  let(:user)        { Fabricate.build(:user, is_admin: true) }
  let(:edit_path)   { edit_admin_moderation_memory_path(memory.id) }
  let(:delete_path) { admin_moderation_memory_path(memory.id) }

  before :each do
    assign(:memory, memory)
    allow(view).to receive(:current_user).and_return(user)
  end

  it_behaves_like "a memory show page"
end

