require 'rails_helper'

describe "memories/show.html.erb" do
  let(:memory) { Fabricate.build(:photo_memory, id: 123) }

  it "has a Back link to the memories page" do
    assign(:memory, memory)
    render
    expect(rendered).to have_link('Back', href: memories_path)
  end

  it_behaves_like "a memory show page"
end
