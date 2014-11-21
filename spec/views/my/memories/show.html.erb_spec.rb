require 'rails_helper'

describe "my/memories/show.html.erb" do
  let(:memory)      { Fabricate.build(:photo_memory, id: 123) }
  let(:user)        { Fabricate.build(:active_user) }
  let(:edit_path)   { edit_my_memory_path(memory.id) }
  let(:delete_path) { my_memory_path(memory.id) }

  before :each do
    allow(view).to receive(:current_user).and_return(user)
  end

  it 'has a link to the current index' do
    assign(:memory, memory)
    render
    expect(rendered).to have_link('Back', href: '/my/memories')
  end

  context "when memory doesn't belong to the user" do
    before :each do
      assign(:memory, memory)
      allow(user).to receive(:can_modify?).and_return(false)
      render
    end

    it "does not have an edit link" do
      expect(rendered).not_to have_link('Edit', href: edit_my_memory_path(memory))
    end

    it "does not have a delete link" do
      expect(rendered).not_to have_link('Delete', href: my_memory_path(memory))
    end
  end

  it_behaves_like "a memory show page"
end
