require 'rails_helper'

describe "admin/moderation/scrapbooks/show.html.erb" do
  let(:state)        { 'unmoderated' }
  let(:user)         { Fabricate.build(:admin_user, id: 456) }
  let(:reason)       { nil }
  let(:moderatable)  { Fabricate.build(:scrapbook, id: 123, user: user, moderation_state: state, moderation_reason: reason) }
  let(:list_path)    { 'test/path' }

  before :each do
    assign(:scrapbook, moderatable)
    assign(:memories, [])
    allow(view).to receive(:current_scrapbook_index_path).and_return(list_path)
  end

  describe 'moderation actions' do
    let(:path_segment) { 'scrapbook' }

    before :each do
      render
    end

    it_behaves_like 'a moderated show page'
  end

  describe "action bar" do
    before :each do
      allow(view).to receive(:current_user).and_return(user)
      render
    end

    it "has a button to the scrapbook index page" do
      render
      expect(rendered).to have_link('Back to moderation', href: list_path)
    end

    it "has an edit link" do
      expect(rendered).to have_link('Edit', href: edit_my_scrapbook_path(moderatable))
    end

    it "has a delete link" do
      expect(rendered).to have_link('Delete', href: my_scrapbook_path(moderatable))
    end

    context "and the scrapbook has no memories" do
      let(:memories) { [] }

      it "has an 'Add more memories' link but it is hidden" do
        expect(rendered).to have_css('.no-memories a', text: 'Add more memories')
      end
    end

    context "and the scrapbook has memories" do
      let(:memories) { [Fabricate.build(:memory, id: 123)] }

      it "has an 'Add more memories' link" do
        expect(rendered).to have_link('Add more memories')
      end
    end
  end

  it_behaves_like 'a scrapbook page'
end
