require 'rails_helper'

describe "admin/moderation/users/index.html.erb" do
  it_behaves_like 'a tabbed admin page' do
    let(:active_tab) { 'Moderation' }
  end

  let(:users) { Array.new(3) {|i| Fabricate.build(:user, id: i+1) } }

  before :each do
    assign(:items, users)
  end

  describe 'the navbar' do
    before :each do
      allow(view).to receive(:action_name).and_return(action)
      render
    end

    context 'when viewing from the index action' do
      let(:action) { 'index' }

      it "has a link back to the Inbox view" do
        expect(rendered).to have_link('Back to Inbox', href: admin_home_path)
      end

      it "does not have a link to the all users view" do
        expect(rendered).not_to have_link('All')
      end

      it "has a link to the unmoderated users view" do
        expect(rendered).to have_link('Unmoderated', href: unmoderated_admin_moderation_users_path)
      end

      it "has a link to the reported users view" do
        expect(rendered).to have_link('Reported', href: reported_admin_moderation_users_path)
      end

      it "has a link to the blocked users view" do
        expect(rendered).to have_link('Blocked', href: blocked_admin_moderation_users_path)
      end
    end

    context 'when viewing from the unmoderated action' do
      let(:action) { 'unmoderated' }

      it "has a link back to the Inbox view" do
        expect(rendered).to have_link('Back to Inbox', href: admin_home_path)
      end

      it "has a link to the all users view" do
        expect(rendered).to have_link('All', href: admin_moderation_users_path)
      end

      it "does not have a link to the unmoderated users view" do
        expect(rendered).not_to have_link('Unmoderated')
      end

      it "has a link to the reported users view" do
        expect(rendered).to have_link('Reported', href: reported_admin_moderation_users_path)
      end

      it "has a link to the blocked users view" do
        expect(rendered).to have_link('Blocked', href: blocked_admin_moderation_users_path)
      end
    end

    context 'when viewing from the reported action' do
      let(:action) { 'reported' }

      it "has a link back to the Inbox view" do
        expect(rendered).to have_link('Back to Inbox', href: admin_home_path)
      end

      it "has a link to the all users view" do
        expect(rendered).to have_link('All', href: admin_moderation_users_path)
      end

      it "has a link to the unmoderated users view" do
        expect(rendered).to have_link('Unmoderated', href: unmoderated_admin_moderation_users_path)
      end

      it "does not have a link to the reported users view" do
        expect(rendered).not_to have_link('Reported')
      end

      it "has a link to the blocked users view" do
        expect(rendered).to have_link('Blocked', href: blocked_admin_moderation_users_path)
      end
    end

    context 'when viewing from the blocked action' do
      let(:action) { 'blocked' }

      it "has a link back to the Inbox view" do
        expect(rendered).to have_link('Back to Inbox', href: admin_home_path)
      end

      it "has a link to the all users view" do
        expect(rendered).to have_link('All', href: admin_moderation_users_path)
      end

      it "has a link to the unmoderated users view" do
        expect(rendered).to have_link('Unmoderated', href: unmoderated_admin_moderation_users_path)
      end

      it "has a link to the reported users view" do
        expect(rendered).to have_link('Reported', href: reported_admin_moderation_users_path)
      end

      it "does not have a link to the blocked users view" do
        expect(rendered).not_to have_link('Blocked')
      end
    end
  end

  describe 'the list of users' do
    it "shows each of the given users" do
      render
      expect(rendered).to have_css('tr.user', count: 3)
    end

    describe 'a user' do
      let(:user)       { users.first }
      let(:moderator)  { Fabricate.build(:admin_user, id: 789) }
      let(:active)     { false }
      let(:is_group)   { false }

      before :each do
        allow(user).to receive(:active?).and_return(active)
        allow(user).to receive(:is_group?).and_return(is_group)
        allow(user).to receive(:moderated_by).and_return(moderator)
        render
      end

      it 'has a link to the user' do
        expect(rendered).to have_link(user.screen_name, href: admin_moderation_user_path(user))
      end

      it "shows the user's name" do
        expect(rendered).to have_css('td', text: user.name)
      end

      it "has a mailto link to the user's email" do
        expect(rendered).to have_link(user.email, href: "mailto:#{user.email}")
      end

      describe 'shows the whether the user is active or not' do
        context 'when the user is not active' do
          let(:active) { false }

          it 'displays false' do
            expect(rendered).to have_css('td:nth-child(4)', text: "false")
          end
        end

        context 'when the user is active' do
          let(:active) { true }

          it 'displays true' do
            expect(rendered).to have_css('td:nth-child(4)', text: "true")
          end
        end
      end

      describe 'shows the whether the user is a group or not' do
        context 'when the user is not a group' do
          let(:is_group) { false }

          it 'displays false' do
            expect(rendered).to have_css('td:nth-child(5)', text: "false")
          end
        end

        context 'when the user is a group' do
          let(:is_group) { true }

          it 'displays true' do
            expect(rendered).to have_css('td:nth-child(5)', text: "true")
          end
        end
      end

      it 'shows the current moderation state for the user' do
        expect(rendered).to have_css('td', text: user.moderation_state)
      end

      it 'has a link to the moderator' do
        expect(rendered).to have_link(moderator.screen_name, href: admin_moderation_user_path(moderator))
      end
    end
  end
end

