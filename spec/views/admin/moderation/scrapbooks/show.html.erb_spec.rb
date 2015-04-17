require 'rails_helper'

describe "admin/moderation/scrapbooks/show.html.erb" do
  it_behaves_like 'a scrapbook page'

  describe 'moderation actions' do
    let(:user)         { Fabricate.build(:admin_user, id: 456) }
    let(:reason)       { nil }
    let(:list_path)    { 'test/path' }
    let(:moderatable)  { Fabricate.build(:scrapbook, id: 123, user: user, moderation_state: state, moderation_reason: reason) }
    let(:path_segment) { 'scrapbook' }

    before :each do
      assign(:scrapbook, moderatable)
      assign(:memories, [])
      allow(view).to receive(:current_scrapbook_index_path).and_return(list_path)
      render
    end

    it_behaves_like 'a moderated show page'
  end
end
