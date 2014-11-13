require 'rails_helper'

describe Admin::HomeController do
  describe 'GET index' do
    context "when user is not logged in" do
      it 'asks user to signin as an admin' do
        get :index
        expect(response).to redirect_to(:signin)
        expect(flash[:alert]).to eql("You must be signed in as an administrator to do that")
      end
    end

    context "when user is logged in but not as an admin" do
      before :each do
        @user = Fabricate.build(:active_user)
        login_user
      end

      it 'asks user to signin as an admin' do
        get :index
        expect(response).to redirect_to(:signin)
        expect(flash[:alert]).to eql("You must be signed in as an administrator to do that")
      end
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
