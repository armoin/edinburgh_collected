require 'rails_helper'

describe UsersController do
  describe 'GET new' do
    before :each do
      get :new
    end

    it 'renders the signup page' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:user_params) {{
      first_name: 'Bobby',
      last_name: 'Tables',
      email: 'bobby@example.com',
      username: 'bobbyt',
      password: 'password',
      password_confirmation: 'password'
    }}

    before :each do
      allow(UserWrapper).to receive(:create).and_return(true)
      post :create, user: user_params
    end

    it 'creates a new user' do
      expect(UserWrapper).to have_received(:create).with(user_params)
    end

    context 'when successful' do
      it 'sets a flash notice' do
        expect(flash[:notice]).to eql('Successfully signed up')
      end

      it 'redirects to the login page' do
        expect(response).to redirect_to(:login)
      end
    end

    context 'when unsuccessful' do
      before :each do
        allow(UserWrapper).to receive(:create).and_return(false)
        post :create, user: user_params
      end

      it 'sets a flash alert' do
        expect(flash[:alert]).to eql('Could not sign up new user')
      end

      it 'redirects to the root page' do
        expect(response).to redirect_to(:root)
      end
    end
  end
end
