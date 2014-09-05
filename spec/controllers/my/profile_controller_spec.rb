require 'rails_helper'

describe My::ProfileController do
  describe 'GET show' do
    context 'when not logged in' do
      it 'asks user to login' do
        get :show
        expect(response).to redirect_to(:login)
      end
    end

    context 'when logged in' do
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

  describe 'GET edit' do
    context 'when not logged in' do
      it 'asks user to login' do
        get :edit
        expect(response).to redirect_to(:login)
      end
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate(:user)
        login_user
        get :edit
      end

      it 'assigns the current user' do
        expect(assigns[:user]).to eql(@user)
      end

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PUT update' do
    context 'when not logged in' do
      it 'asks user to login' do
        put :update
        expect(response).to redirect_to(:login)
      end
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate(:user)
        login_user
        allow(@user).to receive(:update_attributes).and_return(true)
        put :update, user: {first_name: 'Mary'}
      end

      it 'assigns the current user' do
        expect(assigns[:user]).to eql(@user)
      end

      it 'updates the current user' do
        expect(@user).to have_received(:update_attributes).with(first_name: 'Mary')
      end

      context 'when successful' do
        before :each do
          allow(@user).to receive(:update_attributes).and_return(true)
          put :update, user: {first_name: 'Mary'}
        end

        it 'redirects to the show page' do
          expect(response).to redirect_to(my_profile_path)
        end

        it 'shows a success notice' do
          expect(flash[:notice]).to eql('Successfully changed your details.')
        end
      end

      context 'when not successful' do
        before :each do
          allow(@user).to receive(:update_attributes).and_return(false)
          put :update, user: {first_name: 'Mary'}
        end

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end
    end
  end
end

