require 'rails_helper'

describe My::ProfileController do
  context 'when logged in' do
    describe 'GET show' do
      before :each do
        @user = Fabricate(:user)
        login_user
        get :show
      end

      it 'assigns the current user' do
        expect(assigns[:user]).to eql(@user)
      end

      it 'renders the show page' do
        expect(response).to render_template(:show)
      end
    end
  end
end

