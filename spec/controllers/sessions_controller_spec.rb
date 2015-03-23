require 'rails_helper'

describe SessionsController do
  describe 'GET new' do
    before :each do
      get :new
    end

    it 'assigns a new user' do
      expect(assigns[:user]).to be_a(User)
      expect(assigns[:user]).to be_new_record
    end

    it 'renders the signin page' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:user)          { Fabricate(:active_user, id: 123) }
    let(:authenticator) { double(Authenticator) }
    let(:authenticated) { true }
    let(:email)         { 'bobby@example.com' }
    let(:pass)          { 's3cr3t' }
    let(:admin)         { false }
    let(:error_message) { nil }

    let(:signin_params) {{
      email:    email,
      password: pass
    }}

    before :each do
      allow(Authenticator).to receive(:new).with(email, pass).and_return(authenticator)
      allow(authenticator).to receive(:user_authenticated?).and_return(authenticated)
      allow(authenticator).to receive(:error_message).and_return(error_message)

      allow(controller).to receive(:login).and_return(user)
      allow(user).to receive(:is_admin?).and_return(admin)

      post :create, signin_params
    end

    it 'authenticates the user' do
      expect(authenticator).to have_received(:user_authenticated?)
    end

    context 'when successful' do
      let(:authenticated) { true }

      it 'signs the user in' do
        expect(controller).to have_received(:login).with(email, pass)
      end

      it 'assigns the signed in user' do
        expect(assigns[:user]).to eql(user)
      end

      context 'when the user is not an admin' do
        let(:admin) { false }

        it 'redirects to the my memories page' do
          expect(response).to redirect_to(my_memories_path)
        end
      end

      context 'and the user is an admin' do
        let(:admin) { true }

        it 'redirects to the admin home page' do
          expect(response).to redirect_to(admin_home_path)
        end
      end

      it 'displays a success notice' do
        expect(flash[:notice]).to eql('Successfully signed in')
      end
    end

    context 'when unsuccessful' do
      let(:authenticated) { false }
      let(:error_message) { 'This is the error message' }

      it 'redirects to the signin page' do
        expect(response).to redirect_to(:signin)
      end

      it 'displays a failure alert' do
        expect(flash[:alert]).to eql(error_message)
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      allow(controller).to receive(:logout)
      delete :destroy
    end

    it 'logs the user out' do
      expect(controller).to have_received(:logout)
    end

    it 'redirects to the root page' do
      expect(response).to redirect_to(:root)
    end

    it 'displays a success notice' do
      expect(flash[:notice]).to eql('Signed out')
    end
  end
end
