require 'rails_helper'

describe "search/scrapbooks/show.html.erb" do
  describe "back button" do
    let(:scrapbook) { Fabricate.build(:scrapbook, id: 456, user: Fabricate.build(:user, id: 123)) }
    let(:memories)  { double(any?: false) }
    let(:query)     { 'test string' }

    before :each do
      allow(view).to receive(:params).and_return(query: query)

      assign(:scrapbook, scrapbook)
      assign(:memories, memories)

      render
    end

    it "has a button to the search results page" do
      expect(rendered).to have_link('Search results', href: search_scrapbooks_path(query: query))
    end
  end

  it_behaves_like 'a scrapbook page'
end
