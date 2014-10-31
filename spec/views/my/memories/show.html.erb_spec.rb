require 'rails_helper'

describe "my/memories/show.html.erb" do
  let(:memory) { Fabricate.build(:photo_memory, id: 123) }

  it "has a Back link to the my_memories page" do
    assign(:memory, memory)
    render
    expect(rendered).to have_link('Back', href: my_memories_path)
  end

  context "when memory doesn't belong to the user" do
    before :each do
      assign(:memory, memory)
      allow(view).to receive(:belongs_to_user?).and_return(false)
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
