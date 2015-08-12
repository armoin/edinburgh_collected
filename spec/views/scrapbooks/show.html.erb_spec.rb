require 'rails_helper'

describe "scrapbooks/show.html.erb" do
  describe "back button" do
    let(:scrapbook) { Fabricate.build(:scrapbook, id: 456, user: Fabricate.build(:user, id: 123)) }
    let(:memories)  { double(any?: false) }

    before :each do
      assign(:scrapbook, scrapbook)
      assign(:memories, memories)

      render
    end

    it "has a button to the scrapbook index page" do
      expect(rendered).to have_link('All scrapbooks', href: scrapbooks_path)
    end
  end

  it_behaves_like 'a scrapbook page'
end
