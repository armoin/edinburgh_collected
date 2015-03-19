require 'rails_helper'

describe "admin/users/index.html.erb" do
  let(:users) { Array.new(3) {|i| Fabricate.build(:user, id: i+1) } }

  before :each do
    assign(:users, users)
  end

  it_behaves_like 'a user index navbar'

  it_behaves_like 'a user index'
end

