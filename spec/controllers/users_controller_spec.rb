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
    let(:user_params) { Fabricate.attributes_for(:user) }
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
        expect(flash[:notice]).to eql('Please click the link in the activation email we have just sent in order to continue.')
      end

      it 'redirects to the root page' do
        expect(response).to redirect_to(:root)
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

  describe 'GET activate' do
    let(:user)       { Fabricate.build(:pending_user) }
    let(:successful) { true }

    before :each do
      allow(User).to receive(:load_from_activation_token).and_return(user)
      allow(user).to receive(:activate!).and_return(successful)
      get :activate, id: '123abc'
    end

    it 'fetches the user' do
      expect(User).to have_received(:load_from_activation_token).with('123abc')
    end

    it 'assigns the user' do
      expect(assigns[:user]).to eql(user)
    end

    context 'when successful' do
      let(:successful) { true }

      it 'activates the user' do
        expect(user).to have_received(:activate!)
      end

      it 'redirects to the sign in page' do
        expect(response).to redirect_to(:login)
      end

      it 'displays a success notice' do
        expect(flash[:notice]).to eq('User was successfully activated.')
      end
    end

    context 'when not successful' do
      let(:successful) { false }

      it 'is not authenticated' do
        expect(response.status).to eql(302)
      end
    end
  end
end
