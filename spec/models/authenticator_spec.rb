require 'rails_helper'

describe Authenticator do
  let(:user_email) { 'bobby@example.com' }
  let(:user_pass)  { 's3cr3t' }

  subject { Authenticator.new(creds[:email], creds[:pass]) }

  describe 'a user' do
    context 'who is active' do
      let!(:user) { Fabricate(:active_user, email: user_email, password: user_pass, password_confirmation: user_pass) }

      context 'and not blocked' do
        context 'when the correct credentials are given' do
          let(:creds) { {email: user_email, pass: user_pass} }

          it "is authenticated" do
            expect(subject.user_authenticated?).to be_truthy
          end
        end

        context "when the incorrect credentials are given" do
          let(:creds) { {email: 'blah@example.com', pass: 'blahblah'} }

          it "is not authenticated" do
            expect(subject.user_authenticated?).to be_falsy
          end

          it "supplies an error message about incorrect email or password" do
            expect(subject.error_message).to eql('Email or password was incorrect.')
          end
        end
      end

      context 'and blocked' do
        before :each do
          user.block! Fabricate(:admin_user)
        end

        context 'when the correct credentials are given' do
          let(:creds) { {email: user_email, pass: user_pass} }

          it "is not authenticated" do
            expect(subject.user_authenticated?).to be_falsy
          end

          it "supplies an error message about incorrect email or password" do
            expect(subject.error_message).to eql('Your account has been blocked. Please contact us if you would like more information.')
          end
        end

        context "when the incorrect credentials are given" do
          let(:creds) { {email: 'blah@example.com', pass: 'blahblah'} }

          it "is not authenticated" do
            expect(subject.user_authenticated?).to be_falsy
          end

          it "supplies an error message about incorrect email or password" do
            expect(subject.error_message).to eql('Email or password was incorrect.')
          end
        end
      end
    end
  end
end