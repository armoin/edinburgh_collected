require 'rails_helper'

describe "admin/moderation/memories/index.html.erb" do
  let(:owner)        { Fabricate.build(:user, id: 123) }
  let(:admin)        { Fabricate.build(:admin_user, id: 456) }
  let(:items)        { Array.new(3) {|n| Fabricate.build(:memory, id: n+1, user: owner) } }
  let(:path_segment) { 'memories' }

  before :each do
    assign(:items, items)
  end

  it_behaves_like 'a moderation index navbar'

  it_behaves_like 'a moderation index'
end

