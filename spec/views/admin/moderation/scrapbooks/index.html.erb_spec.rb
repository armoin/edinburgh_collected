require 'rails_helper'

describe "admin/moderation/scrapbooks/index.html.erb" do
  let(:owner)        { Fabricate.build(:user, id: 123) }
  let(:admin)        { Fabricate.build(:admin_user, id: 456) }
  let(:items)        { Array.new(3) {|n| Fabricate.build(:scrapbook, id: n+1, user: owner) } }
  let(:path_segment) { 'scrapbooks' }

  before :each do
    assign(:items, items)
  end

  it_behaves_like 'a moderation index navbar'

  it_behaves_like 'a moderation index'
end

