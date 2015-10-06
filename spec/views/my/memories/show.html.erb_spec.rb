require 'rails_helper'

describe "my/memories/show.html.erb" do
  describe "action bar" do
    let(:owner)  { Fabricate.build(:active_user, id: 123) }
    let(:memory) { Fabricate.build(:photo_memory, id: 456, user: owner) }
    let(:page)   { '2' }

    before :each do
      assign(:memory, memory)
      assign(:page, page)
      allow(view).to receive(:current_user).and_return(owner)
      render
    end

    it 'has a button to "All my memories"' do
      expect(rendered).to have_link('All my memories', href: my_memories_path)
    end

    it "has an edit link" do
      expect(rendered).to have_link('Edit', href: edit_my_memory_path(memory.id))
    end

    it "has a delete link" do
      expect(rendered).to have_link('Delete', href: my_memory_path(memory.id))
    end

    it "shows the 'Add to scrapbook' button" do
      expect(rendered).to have_link('Scrapbook')
    end

    it 'does not have a report button' do
      expect(rendered).not_to have_link('Report a concern')
    end
  end

  it_behaves_like 'a memory page'
end
