require 'rails_helper'

describe "search/memories/show.html.erb" do
  describe "action bar" do
    let(:user)   { Fabricate.build(:active_user, id: 123)}
    let(:memory) { Fabricate.build(:photo_memory, id: 456, user: user) }

    before :each do
      assign(:memory, memory)
      assign(:query, query)
      render
    end

    context 'when no query is given' do
      let(:query) { nil }

      it "has a back button to the search memories index page with a nil query string" do
        expect(rendered).to have_link('Back', href: search_memories_path(query: nil))
      end
    end

    context 'when a query is given' do
      let(:query) { 'This is a query string' }

      it "has a back button to the search memories index page with the given query string" do
        expect(rendered).to have_link('Back', href: search_memories_path(query: 'This is a query string'))
      end
    end
  end

  it_behaves_like 'a memory page'
end
