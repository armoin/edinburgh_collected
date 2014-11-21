require 'rails_helper'

describe "memories/show.html.erb" do
  let(:memory) { Fabricate.build(:photo_memory, id: 123) }
  let(:edit_path)   { edit_my_memory_path(memory.id) }
  let(:delete_path) { my_memory_path(memory.id) }

  it 'has a link to the current index' do
    assign(:memory, memory)
    render
    expect(rendered).to have_link('Back', href: '/memories')
  end

  it_behaves_like "a memory show page"
end
