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

    it 'renders the login page' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:login_params) {{
      email: 'bobby@example.com',
      password: 's3cr3t'
    }}

    before :each do
      allow(controller).to receive(:login).and_return(true)
      post :create, login_params
    end

    it 'logs the user in' do
      expect(controller).to have_received(:login).with('bobby@example.com', 's3cr3t')
    end

    context 'when successful' do
      it 'redirects to the root page' do
        expect(response).to redirect_to(:root)
      end

      it 'displays a success notice' do
        expect(flash[:notice]).to eql('Successfully signed in')
      end
    end

    context 'when unsuccessful' do
      before :each do
        allow(controller).to receive(:login).and_return(false)
        post :create, login_params
      end

      it 'renders the login page' do
        expect(response).to render_template(:new)
      end

      it 'displays a failure alert' do
        expect(flash[:alert]).to eql('Could not sign in')
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
