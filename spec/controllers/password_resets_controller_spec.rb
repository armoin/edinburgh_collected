require 'rails_helper'

describe PasswordResetsController do
  describe 'GET new' do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:email) { 'bobby@example.com' }
    let(:user)  { Fabricate.build(:user, email: email) }

    before :each do
      allow_message_expectations_on_nil
      allow(User).to receive(:find_by_email).and_return(user)
      allow(user).to receive(:deliver_reset_password_instructions!)
      post :create, email: email
    end

    it "finds the user by the given email" do
      expect(User).to have_received(:find_by_email).with(email)
    end

    it "assigns the user" do
      expect(assigns[:user]).to eql(user)
    end

    context "when user exists" do
      let(:user) { Fabricate.build(:user) }

      it "delivers the password reset email" do
        expect(user).to have_received(:deliver_reset_password_instructions!)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to(:root)
      end

      it "lets the user know that instructions have been sent" do
        expect(flash[:notice]).to eql('Instructions have been sent to your email.')
      end
    end

    context "when user does not exist" do
      let(:user) { nil }

      it "does not deliver the password reset email" do
        expect(user).not_to have_received(:deliver_reset_password_instructions!)
      end

      it "re-renders the password reset page" do
        expect(response).to render_template(:new)
      end

      it "shows an email not found error" do
        expect(flash[:alert]).to eql("Sorry but we don't recognise the email address \"#{email}\".")
      end
    end
  end

  describe 'GET edit' do
    let(:token) { '123abc' }
    let(:user)  { Fabricate.build(:user, reset_password_token: token) }

    before :each do
      allow(User).to receive(:load_from_reset_password_token).and_return(user)
      get :edit, id: token
    end

    it "finds the user by the given token" do
      expect(User).to have_received(:load_from_reset_password_token).with(token)
    end

    it "assigns the user" do
      expect(assigns[:user]).to eql(user)
    end

    it "assigns the token" do
      expect(assigns[:token]).to eql(token)
    end

    context "when user exists" do
      let(:user)  { Fabricate.build(:user, reset_password_token: token) }

      it "renders the password reset page" do
        expect(response).to render_template(:edit)
      end
    end

    context "when user does not exist" do
      let(:user) { nil }

      it "is not authenticated" do
        expect(response.status).to eql(302)
      end
    end
  end

  describe 'PUT update' do
    let(:token) { '123abc' }
    let(:user)  { Fabricate.build(:user, reset_password_token: token) }

    before :each do
      allow_message_expectations_on_nil
      allow(User).to receive(:load_from_reset_password_token).and_return(user)
      allow(user).to receive(:password_confirmation=)
      allow(user).to receive(:change_password!).and_return(true)
      put :update, id: token, user: {password: 'newpass', password_confirmation: 'newpass'}
    end

    it "finds the user by the given token" do
      expect(User).to have_received(:load_from_reset_password_token).with(token)
    end

    it "assigns the user" do
      expect(assigns[:user]).to eql(user)
    end

    it "assigns the token" do
      expect(assigns[:token]).to eql(token)
    end

    context "when user exists" do
      let(:user)  { Fabricate.build(:user, reset_password_token: token) }

      it "sets the password_confirmation" do
        expect(user).to have_received(:password_confirmation=).with('newpass')
      end

      it "changes the password" do
        expect(user).to have_received(:change_password!).with('newpass')
      end

      context "when the password is successfully changed" do
        before :each do
          allow(user).to receive(:change_password!).and_return(true)
          put :update, id: token, user: {password: 'newpass', password_confirmation: 'newpass'}
        end

        it "redirects to the signin path" do
          expect(response).to redirect_to(:signin)
        end

        it "notifies the user that the password has been reset" do
          expect(flash[:notice]).to eql('Password was successfully updated.')
        end
      end

      context "when the password is not successfully changed" do
        before :each do
          allow(user).to receive(:change_password!).and_return(false)
          put :update, id: token, user: {password: 'newpass', password_confirmation: 'newpass'}
        end

        it "renders the password reset page again" do
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when user does not exist" do
      let(:user) { nil }

      it "is not authenticated" do
        expect(response.status).to eql(302)
      end

      it "does not set the password_confirmation" do
        expect(user).not_to have_received(:password_confirmation=)
      end

      it "does not change the password" do
        expect(user).not_to have_received(:change_password!)
      end
    end
  end
end
