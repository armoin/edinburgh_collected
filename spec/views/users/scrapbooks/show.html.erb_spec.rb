require 'rails_helper'

describe "users/scrapbooks/show.html.erb" do
  let(:requested_user) { Fabricate.build(:user, id: 123) }

  before :each do
    assign(:requested_user, requested_user)
  end

  describe "back button" do
    let(:scrapbook) { Fabricate.build(:scrapbook, id: 456, user: requested_user) }
    let(:memories)  { double(any?: false) }

    before :each do
      assign(:scrapbook, scrapbook)
      assign(:memories, memories)

      render
    end

    it "has a button to the users scrapbook index page" do
      expect(rendered).to have_link('More scrapbooks from this user', href: user_scrapbooks_path(requested_user))
    end
  end

  it_behaves_like 'a scrapbook page'
end
