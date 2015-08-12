require 'rails_helper'

describe "my/memories/show.html.erb" do
  describe "action bar" do
    let(:owner)  { Fabricate.build(:active_user, id: 123) }
    let(:memory) { Fabricate.build(:photo_memory, id: 456, user: owner) }
    let(:page)   { '2' }

    before :each do
      assign(:memory, memory)
      assign(:page, page)
      render
    end

    it 'has a button to "All my memories"' do
      expect(rendered).to have_link('All my memories', href: my_memories_path)
    end
  end

  it_behaves_like 'a memory page'
end
