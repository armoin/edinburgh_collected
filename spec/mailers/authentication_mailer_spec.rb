require "rails_helper"

describe AuthenticationMailer do
  let(:user) { Fabricate.build(:user, reset_password_token: '123abc', activation_token: '456def') }

  describe "reset_password_email" do
    let(:mail) { AuthenticationMailer.reset_password_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Reset password")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([CONTACT_EMAIL])
    end

    EMAIL_PARTS.each do |content_type|
      context "#{content_type}" do
        let(:body) { get_body_for(mail, content_type) }

        it "greets the user" do
          expect(body).to match("Hi #{user.screen_name}")
        end

        it "provides the reset password URL" do
          expect(body).to match(edit_password_reset_url('123abc'))
        end

        it "signs off from the app team" do
          expect(body).to match("The #{APP_NAME} Team")
        end
      end
    end
  end

  describe "activation_needed_email" do
    let(:mail) { AuthenticationMailer.activation_needed_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Please activate your account")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([CONTACT_EMAIL])
    end

    EMAIL_PARTS.each do |content_type|
      context "#{content_type}" do
        let(:body) { get_body_for(mail, content_type) }

        it "greets the user" do
          expect(body).to match("Hi #{user.screen_name}")
        end

        it "provides the activation URL" do
          expect(body).to match(activate_user_url(user.activation_token))
        end

        it "signs off from the app team" do
          expect(body).to match("The #{APP_NAME} Team")
        end
      end
    end
  end

  describe "activation_success_email" do
    let(:mail) { AuthenticationMailer.activation_success_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome to #{APP_NAME}")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([CONTACT_EMAIL])
    end

    EMAIL_PARTS.each do |content_type|
      context "#{content_type}" do
        let(:body) { get_body_for(mail, content_type) }

        it "greets the user" do
          expect(body).to match("Hi #{user.screen_name}")
        end

        it "provides the sign in URL" do
          expect(body).to match(signin_url)
        end

        it "signs off from the app team" do
          expect(body).to match("The #{APP_NAME} Team")
        end
      end
    end
  end
end
