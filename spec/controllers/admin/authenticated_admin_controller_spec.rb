require 'rails_helper'

class ProtectedAdminController < Admin::AuthenticatedAdminController; end

describe Admin::AuthenticatedAdminController do
  controller ProtectedAdminController do
    skip_before_action :require_admin, only: [:index]

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
        routes.draw { get 'secret' => 'protected_admin#secret' }
        get :secret
      end

      it "redirects to the signin page" do
        expect(response).to redirect_to(:signin)
      end

      it "alerts the user to sign in" do
        expect(flash[:alert]).to eql('You must be signed in as an administrator to do that')
      end
    end

    it 'ignores any pages marked as unauthenticated' do
      get :index
      expect(response).to be_success
    end
  end
end
