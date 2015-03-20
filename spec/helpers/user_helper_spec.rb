require 'rails_helper'

describe UserHelper do
  describe '#greet' do
    it 'provides a welcome link' do
      expected = "<a href=\"#{my_profile_path}\">Welcome, bob</a>"
      expect(helper.greet('bob')).to eql(expected)
    end
  end

  describe '#user_name_label' do
    it "returns 'Group name' if the user is a group" do
      user = double(is_group?: true)
      expect(helper.user_name_label(user)).to eql('Group name')
    end

    it "returns 'First name' if the user is an individual" do
      user = double(is_group?: false)
      expect(helper.user_name_label(user)).to eql('First name')
    end
  end

  describe '#block_toggle_button_for' do
    context 'when the user is not currently blocked' do
      let(:user)   { Fabricate.build(:active_user, id: 123) }
      let(:result) { helper.block_toggle_button_for(user) }

      it 'allows the admin to block a user' do
        expect(result).to include('Block user')
        expect(result).to include('href="/admin/users/123/block"')
      end

      it 'sends a PUT request' do
        expect(result).to include('data-method="put"')
      end

      it 'asks the user to confirm' do
        expect(result).to include('data-confirm="Are you sure?"')
      end

      it 'displays the link as a red button' do
        expect(result).to include('class="button red"')
      end
    end

    context 'when the user is currently blocked' do
      let(:user)   { Fabricate.build(:blocked_user, id: 123) }
      let(:result) { helper.block_toggle_button_for(user) }

      it 'allows the admin to unblock a user' do
        expect(result).to include('Unblock user')
        expect(result).to include('href="/admin/users/123/unblock"')
      end

      it 'sends a PUT request' do
        expect(result).to include('data-method="put"')
      end

      it 'asks the user to confirm' do
        expect(result).to include('data-confirm="Are you sure?"')
      end

      it 'displays the link as a red button' do
        expect(result).to include('class="button red"')
      end
    end
  end

  describe '#user_list_button_for' do
    context 'when the user is not currently blocked' do
      let(:user)   { Fabricate.build(:active_user, id: 123) }
      let(:result) { helper.user_list_button_for(user) }

      it 'links back to the Show all users index page' do
        expect(result).to have_link('Back', href: admin_users_path)
      end
    end

    context 'when the user is currently blocked' do
      let(:user)   { Fabricate.build(:blocked_user, id: 123) }
      let(:result) { helper.user_list_button_for(user) }

      it 'links back to the Show blocked users index page' do
        expect(result).to have_link('Back', href: blocked_admin_users_path)
      end
    end
  end
end

