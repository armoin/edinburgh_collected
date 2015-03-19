require 'rails_helper'

describe 'admin/users/show.html.erb' do
  it_behaves_like 'a user profile'

  describe 'admin actions' do
    let(:requested_user) { Fabricate.build(:active_user, id: 123) }

    before :each do
      assign(:user, requested_user)
      render
    end

    it 'allows the admin to block a user' do
      expect(rendered).to have_link('Block user', href: block_admin_user_path(requested_user))
    end

    it 'confirms a block request with the admin' do
      expect(rendered).to have_css('a[data-confirm="Are you sure?"]', text: 'Block user')
    end
  end
end
