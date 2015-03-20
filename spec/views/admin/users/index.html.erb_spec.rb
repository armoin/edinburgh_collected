require 'rails_helper'

describe "admin/users/index.html.erb" do
  let(:users) { Array.new(3) {|i| Fabricate.build(:user, id: i+1) } }

  before :each do
    assign(:users, users)
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

      it "does not have a link to the Show all view" do
        expect(rendered).not_to have_link('Show all')
      end

      it "has a link to the Show blocked view" do
        expect(rendered).to have_link('Show blocked', href: blocked_admin_users_path)
      end
    end

    context 'when viewing from the blocked action' do
      let(:action) { 'blocked' }

      it "has a link back to the Inbox view" do
        expect(rendered).to have_link('Back to Inbox', href: admin_home_path)
      end

      it "has a link to the Show all view" do
        expect(rendered).to have_link('Show all', href: admin_users_path)
      end

      it "does not have a link to the Show blocked view" do
        expect(rendered).not_to have_link('Show blocked')
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
      let(:active)     { false }
      let(:is_group)   { false }
      let(:is_blocked) { false }

      before :each do
        allow(user).to receive(:active?).and_return(active)
        allow(user).to receive(:is_group?).and_return(is_group)
        allow(user).to receive(:is_blocked?).and_return(is_blocked)
        render
      end

      it 'has a link to the user' do
        expect(rendered).to have_link(user.screen_name, href: admin_user_path(user))
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

      describe 'shows the whether the user is blocked or not' do
        context 'when the user is not blocked' do
          let(:is_blocked) { false }

          it 'displays false' do
            expect(rendered).to have_css('td:nth-child(6)', text: "false")
          end
        end

        context 'when the user is blocked' do
          let(:is_blocked) { true }

          it 'displays true' do
            expect(rendered).to have_css('td:nth-child(6)', text: "true")
          end
        end
      end
    end
  end
end

