require 'rails_helper'

class ProtectedController < User::AuthenticatedUserController; end

describe User::AuthenticatedUserController do
  controller ProtectedController do
    skip_before_filter :authenticate!, only: [:index]

    def index
      render text: 'index'
    end

    def secret
      render text: 'show'
    end
  end

  describe 'authentication' do
    context 'authenticates pages by default' do
      before :each do
        routes.draw { get 'secret' => 'protected#secret' }
        get :secret
      end

      it "redirects to the login page" do
        expect(response).to redirect_to(:login)
      end

      it "alerts the user to log in" do
        expect(flash[:alert]).to eql('You must be logged in to access that.')
      end
    end

    it 'ignores any pages marked as unauthenticated' do
      get :index
      expect(response).to be_success
    end
  end
end
