require 'rails_helper'

describe 'admin/moderation/memories/show.html.erb' do
  let(:memory) { Fabricate.build(:photo_memory, id: 123) }
  let(:user)   { Fabricate.build(:user) }

  before :each do
    assign(:memory, memory)
    allow(view).to receive(:current_user).and_return(user)
  end

  context "when user isn't an admin" do
    before :each do
      allow(user).to receive(:is_admin?).and_return(false)
      render
    end

    it "does not have an edit link" do
      expect(rendered).not_to have_link('Edit', href: edit_admin_moderation_memory_path(memory))
    end

    it "does not have a delete link" do
      expect(rendered).not_to have_link('Delete', href: admin_moderation_memory_path(memory))
    end
  end

  context "when user is an admin" do
    before :each do
      allow(user).to receive(:is_admin?).and_return(true)
      render
    end

    it "has an edit link" do
      expect(rendered).to have_link('Edit', href: edit_admin_moderation_memory_path(memory))
    end

    it "has a delete link" do
      expect(rendered).to have_link('Delete', href: admin_moderation_memory_path(memory))
    end
  end

  it_behaves_like "a memory show page"
end

