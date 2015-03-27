require 'rails_helper'

describe 'admin/moderation/users/show.html.erb' do
  it_behaves_like 'a user profile'

  describe 'actions' do
    let(:requested_user) { Fabricate.build(:active_user, id: 123) }

    before :each do
      assign(:user, requested_user)
      render
    end

    it 'does not have an Edit link' do
      expect(rendered).not_to have_link('Edit')
    end

    describe 'admin actions' do
      context 'when the user is not currently blocked' do
        let(:requested_user) { Fabricate.build(:active_user, id: 123) }

        it 'has a Back link to the Show all users index page' do
          expect(rendered).to have_link('Back', href: admin_moderation_users_path)
        end

        it 'allows the admin to block a user' do
          expect(rendered).to have_link('Block user', href: block_admin_moderation_user_path(requested_user))
        end

        it 'confirms a block request with the admin' do
          expect(rendered).to have_css('a[data-confirm="Are you sure?"]', text: 'Block user')
        end
      end

      context 'when the user is currently blocked' do
        let(:requested_user) { Fabricate.build(:blocked_user, id: 123) }

        it 'allows the admin to unblock a user' do
          expect(rendered).to have_link('Unblock user', href: unblock_admin_moderation_user_path(requested_user))
        end

        it 'confirms an unblock request with the admin' do
          expect(rendered).to have_css('a[data-confirm="Are you sure?"]', text: 'Unblock user')
        end
      end
    end
  end
end
