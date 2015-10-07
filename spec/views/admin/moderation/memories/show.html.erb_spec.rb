require 'rails_helper'

describe 'admin/moderation/memories/show.html.erb' do
  let(:user)        { Fabricate.build(:admin_user, id: 456) }
  let(:moderatable) { Fabricate.build(:memory, id: 123, user: user, moderation_state: state, moderation_reason: reason) }
  let(:state)       { 'unmoderated' }
  let(:reason)      { nil }

  describe 'moderation actions' do
    let(:path_segment) { 'memory' }

    before :each do
      assign(:memory, moderatable)
      render
    end

    it_behaves_like 'a moderated show page'
  end

  describe "action bar" do
    let(:list_path) { 'test/path' }

    before :each do
      allow(view).to receive(:current_user).and_return(user)
      allow(view).to receive(:current_memory_index_path).and_return(list_path)
      assign(:memory, moderatable)
      render
    end

    it 'has a back button to the moderation list page' do
      expect(rendered).to have_link('Back to moderation', href: list_path)
    end

    it "has an edit link" do
      expect(rendered).to have_link('Edit', href: edit_my_memory_path(moderatable.id))
    end

    it "has a delete link" do
      expect(rendered).to have_link('Delete', href: my_memory_path(moderatable.id))
    end

    it "does not show the 'Add to scrapbook' button" do
      expect(rendered).not_to have_link('Scrapbook')
    end

    it 'does not have a report button' do
      expect(rendered).not_to have_link('Report a concern')
    end
  end

  it_behaves_like 'a memory page'
end
