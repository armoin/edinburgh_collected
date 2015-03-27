require 'rails_helper'

describe My::GettingStartedController do
  describe 'GET index' do
    describe 'ensure user is logged in' do
      before :each do
        get :index, format: format
      end

      it_behaves_like 'requires logged in user'
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate.build(:user)
        login_user

        get :index
      end

      it 'displays the getting started page' do
        expect(response).to render_template(:index)
      end
    end
  end
end