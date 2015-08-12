require 'rails_helper'

describe "search/memories/show.html.erb" do
  describe "action bar" do
    let(:user)   { Fabricate.build(:active_user, id: 123)}
    let(:memory) { Fabricate.build(:photo_memory, id: 456, user: user) }
    let(:query)  { 'This is a query string' }

    it "has a button to the search memories page including the given query string" do
      assign(:memory, memory)
      assign(:query, query)

      render

      expect(rendered).to have_link('Search results', href: search_memories_path(query: 'This is a query string'))
    end
  end

  it_behaves_like 'a memory page'
end
