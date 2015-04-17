require 'rails_helper'

describe Admin::HomeController do
  describe 'GET index' do
    context 'user must be logged in as an admin' do
      let(:perform_action) { get :index }

      it_behaves_like 'an admin only controller'
    end

    context "when user is logged in as an admin" do
      before :each do
        @user = Fabricate.build(:admin_user)
        login_user
      end

      it 'is successful' do
        get :index
        expect(response).to be_successful
      end
    end
  end
end
