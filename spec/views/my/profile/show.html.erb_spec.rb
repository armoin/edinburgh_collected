require 'rails_helper'

describe 'my/profile/show.html.erb' do
  it_behaves_like 'a user profile'

  describe "actions" do
    let(:requested_user) { Fabricate.build(:active_user, id: 123) }

    before :each do
      assign(:user, requested_user)
      render
    end

    it 'has an Edit link' do
      expect(rendered).to have_link('Edit', href: my_profile_edit_path)
    end

    describe 'admin actions' do
      context 'when the user is not blocked' do
        let(:requested_user) { Fabricate.build(:active_user, id: 123) }

        it 'does not allow the user to block themselves' do
          expect(rendered).not_to have_link('Block user')
        end

        it 'does not allow the user to unblock themselves' do
          expect(rendered).not_to have_link('Unblock user')
        end
      end

      context 'when the user is blocked' do
        let(:requested_user) { Fabricate.build(:blocked_user, id: 123) }

        it 'does not allow the user to block themselves' do
          expect(rendered).not_to have_link('Block user')
        end

        it 'does not allow the user to unblock themselves' do
          expect(rendered).not_to have_link('Unblock user')
        end
      end
    end
  end
end
