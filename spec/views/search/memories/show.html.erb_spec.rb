require 'rails_helper'

describe "search/memories/show.html.erb" do
  describe "action bar" do
    let(:user)   { Fabricate.build(:active_user, id: 123)}
    let(:memory) { Fabricate.build(:photo_memory, id: 456, user: user) }
    let(:query)  { 'This is a query string' }
    let(:page) { '2' }

    it "has a back button to the search memories page including the given query string and page number" do
      assign(:memory, memory)
      assign(:query, query)
      assign(:page, page)

      render

      expect(rendered).to have_link('Back', href: search_memories_path(query: 'This is a query string', page: '2'))
    end
  end

  it_behaves_like 'a memory page'
end
