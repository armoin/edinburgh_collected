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
    let(:user)    { Fabricate(:active_user, id: 123) }
    let(:blocked) { false }
    let(:admin)   { false }

    let(:signin_params) {{
      email: 'bobby@example.com',
      password: 's3cr3t'
    }}

    before :each do
      allow(controller).to receive(:login).and_return(user)
      allow(controller).to receive(:logout)
      allow(user).to receive(:is_blocked?).and_return(blocked)
      allow(user).to receive(:is_admin?).and_return(admin)
      post :create, signin_params
    end

    it 'logs the user in' do
      expect(controller).to have_received(:login).with('bobby@example.com', 's3cr3t')
    end

    context 'when successful' do
      it 'checks to see if the user is blocked' do
        expect(user).to have_received(:is_blocked?)
      end

      context 'when the user is not blocked' do
        let(:blocked) { false }

        context 'and the user is not an admin' do
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

      context 'when the user is blocked' do
        let(:blocked) { true }

        it 'logs the user out again' do
          expect(controller).to have_received(:logout)
        end

        it 'redirects to the sign in page' do
          expect(response).to redirect_to(:signin)
        end

        it 'displays a failure alert' do
          expect(flash[:alert]).to eql('Your account has been blocked. Please contact an administrator if you would like to have it unblocked.')
        end
      end
    end

    context 'when unsuccessful' do
      before :each do
        allow(controller).to receive(:login).and_return(nil)
        post :create, signin_params
      end

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
