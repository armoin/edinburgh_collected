require 'rails_helper'

describe "admin/moderation/scrapbooks/index.html.erb" do
  it_behaves_like 'a tabbed admin page' do
    let(:active_tab) { 'Moderation' }
  end

  let(:owner)              { Fabricate.build(:user, id: 123) }
  let(:admin)              { Fabricate.build(:admin_user, id: 456) }
  let(:created_at)         { 2.days.ago }
  let(:updated_at)         { 1.day.ago }
  let(:moderated_date_col) { 7 }
  let(:items)              { Array.new(3) {|n| Fabricate.build(:scrapbook, id: n+1,
                                                                     user: owner,
                                                                     created_at: created_at,
                                                                     updated_at: updated_at) } }
  let(:path_segment) { 'scrapbooks' }

  before :each do
    assign(:items, items)
  end

  it_behaves_like 'a moderation index navbar'

  it_behaves_like 'a moderation index'
end

