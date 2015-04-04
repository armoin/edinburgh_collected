require 'rails_helper'

describe ApplicationController do
  controller do
    def index
      render text: 'test'
    end
  end

  describe '#logout_if_access_denied' do
    context 'when the user is not logged in' do
      it 'does not check whether or not the user has been denied access' do
        allow_any_instance_of(User).to receive(:access_denied?)
        get :index
        expect_any_instance_of(User).not_to receive(:access_denied?)
      end
    end

    context 'when the user is logged in' do
      let(:access_denied_result) { false }

      before :each do
        @user = Fabricate.build(:active_user, id: 123)
        login_user

        allow(@user).to receive(:access_denied?) { access_denied_result }
        allow(controller).to receive(:logout)

        get :index
      end

      it 'checks whether or not the user has been denied access' do
        expect(@user).to have_received(:access_denied?)
      end

      context 'and they have not been denied access' do
        let(:access_denied_result) { false }

        it 'does not log them out' do
          expect(controller).not_to have_received(:logout)
        end

        it 'continues with the requested action' do
          expect(response).to be_success
          expect(response.body).to eql('test')
        end
      end

      context 'and they have been denied access' do
        let(:access_denied_result) { true }

        it 'logs them out' do
          expect(controller).to have_received(:logout)
        end

        it 'redirects to the sign in page' do
          expect(response).to redirect_to(:signin)
        end

        it 'shows an error message' do
          expect(flash[:alert]).to eql(@user.access_denied_reason)
        end
      end
    end
  end
end