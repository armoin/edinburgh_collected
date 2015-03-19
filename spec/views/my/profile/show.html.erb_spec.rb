require 'rails_helper'

describe 'my/profile/show.html.erb' do
  it_behaves_like 'a user profile'

  describe 'admin actions' do
    let(:requested_user) { Fabricate.build(:active_user, id: 123) }

    before :each do
      assign(:user, requested_user)
      render
    end

    it 'does not allow the user to block themselves' do
      expect(rendered).not_to have_link('Block user')
    end
  end
end
