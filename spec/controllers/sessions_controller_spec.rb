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
    let(:user)              { Fabricate(:active_user, id: 123) }
    let(:email)             { 'bobby@example.com' }
    let(:pass)              { 's3cr3t' }
    let(:login_result)      { user }
    let(:landing_page_path) { '/my/test/landing/path' }

    let(:signin_params) {{
      email:    email,
      password: pass
    }}

    before :each do
      allow(controller).to receive(:login) { login_result }

      allow(controller).to receive(:landing_page_for).with(user).and_return(landing_page_path)

      post :create, signin_params
    end

    it 'signs the user in' do
      expect(controller).to have_received(:login).with(email, pass)
    end

    context 'when successful' do
      let(:login_result) { user }

      it 'assigns the signed in user' do
        expect(assigns[:user]).to eql(user)
      end

      it 'redirects to the landing page for the user' do
        expect(response).to redirect_to(landing_page_path)
      end

      it 'displays a success notice' do
        expect(flash[:notice]).to eql('Successfully signed in')
      end
    end

    context 'when unsuccessful' do
      let(:login_result) { nil }

      it 'redirects to the signin page' do
        expect(response).to redirect_to(:signin)
      end

      it 'displays a failure alert' do
        expect(flash[:alert]).to eql('Email or password was incorrect.')
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
