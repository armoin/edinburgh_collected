require 'rails_helper'

describe UsersController do
  describe 'GET new' do
    before :each do
      get :new
    end

    it 'assigns a new user' do
      expect(assigns[:user]).to be_a(User)
      expect(assigns[:user]).to be_new_record
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
      password: 'password',
      password_confirmation: 'password'
    }}
    let(:stub_user) { double('user', save: true) }

    before :each do
      allow(User).to receive(:new).and_return(stub_user)
      post :create, user: user_params
    end

    it 'builds a new user' do
      expect(User).to have_received(:new).with(user_params)
    end

    it 'saves the user' do
      expect(stub_user).to have_received(:save)
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
      let(:stub_user) { double('user', save: false) }

      it 'renders the new page' do
        post :create, user: user_params
        expect(response).to render_template(:new)
      end
    end
  end
end
