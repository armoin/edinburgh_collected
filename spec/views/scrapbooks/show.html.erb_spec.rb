require 'rails_helper'

describe "scrapbooks/show.html.erb" do
  describe "back button" do
    let(:scrapbook) { Fabricate.build(:scrapbook, id: 456, user: Fabricate.build(:user, id: 123)) }
    let(:memories)  { double(any?: false) }

    before :each do
      assign(:scrapbook, scrapbook)
      assign(:memories, memories)

      allow(view).to receive(:current_scrapbook_index_path).and_return(scrapbooks_path)

      render
    end

    it "has a back button to the current scrapbook index page" do
      expect(rendered).to have_link('Back', href: scrapbooks_path)
    end
  end

  it_behaves_like 'a scrapbook page'
end
