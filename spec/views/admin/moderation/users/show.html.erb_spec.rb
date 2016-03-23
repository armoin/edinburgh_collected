require 'rails_helper'

describe 'admin/moderation/users/show.html.erb' do
  it_behaves_like 'a user profile'

  describe 'moderation' do
    let(:state)          { 'approved' }
    let(:reason)         { nil }
    let(:requested_user) { Fabricate.build(:active_user, id: 123, moderation_state: state, moderation_reason: reason) }

    before :each do
      assign(:user, requested_user)
      render
    end

    it_behaves_like 'a tabbed admin page' do
      let(:active_tab) { 'Moderation' }
    end

    it_behaves_like 'a page with a state bar'

    describe 'actions' do
      it 'does not have an Edit link' do
        expect(rendered).not_to have_link('Edit')
      end

      describe 'admin actions' do
        context 'when the user is unmoderated' do
          let(:requested_user) { Fabricate.build(:unmoderated_user, id: 123) }

          it 'has a Back link to the Show all users index page' do
            expect(rendered).to have_link('Back', href: admin_moderation_users_path)
          end

          it 'does not have an Unmoderate link to unmoderate the user' do
            expect(rendered).not_to have_link('Unmoderate')
          end

          it 'has an Approve link to approve the user' do
            expect(rendered).to have_link('Approve', href: approve_admin_moderation_user_path(requested_user))
          end

          it 'has a Block link to block the user' do
            expect(rendered).to have_link('Block', href: block_admin_moderation_user_path(requested_user))
          end
        end

        context 'when the user is approved' do
          let(:requested_user) { Fabricate.build(:approved_user, id: 123) }

          it 'has a Back link to the Show all users index page' do
            expect(rendered).to have_link('Back', href: admin_moderation_users_path)
          end

          it 'has an Unmoderate link to unmoderate the user' do
            expect(rendered).to have_link('Unmoderate', href: unmoderate_admin_moderation_user_path(requested_user))
          end

          it 'does not have an Approve link to approve the user' do
            expect(rendered).not_to have_link('Approve')
          end

          it 'has a Block link to block the user' do
            expect(rendered).to have_link('Block', href: block_admin_moderation_user_path(requested_user))
          end
        end

        context 'when the user is blocked' do
          let(:requested_user) { Fabricate.build(:blocked_user, id: 123) }

          it 'has a Back link to the Show all users index page' do
            expect(rendered).to have_link('Back', href: admin_moderation_users_path)
          end

          it 'has an Unmoderate link to unmoderate the user' do
            expect(rendered).to have_link('Unmoderate', href: unmoderate_admin_moderation_user_path(requested_user))
          end

          it 'has an Approve link to approve the user' do
            expect(rendered).to have_link('Approve', href: approve_admin_moderation_user_path(requested_user))
          end

          it 'does not have a Block link to block the user' do
            expect(rendered).not_to have_link('Block')
          end
        end

        context 'when the user is reported' do
          let(:requested_user) { Fabricate.build(:reported_user, id: 123) }

          it 'has a Back link to the Show all users index page' do
            expect(rendered).to have_link('Back', href: admin_moderation_users_path)
          end

          it 'has an Unmoderate link to unmoderate the user' do
            expect(rendered).to have_link('Unmoderate', href: unmoderate_admin_moderation_user_path(requested_user))
          end

          it 'has an Approve link to approve the user' do
            expect(rendered).to have_link('Approve', href: approve_admin_moderation_user_path(requested_user))
          end

          it 'has a Block link to block the user' do
            expect(rendered).to have_link('Block', href: block_admin_moderation_user_path(requested_user))
          end
        end
      end
    end
  end
end
