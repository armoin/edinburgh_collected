require "rails_helper"

describe AuthenticationMailer do
  describe "reset_password_email" do
    let(:user) { Fabricate.build(:user, reset_password_token: '123abc') }
    let(:mail) { AuthenticationMailer.reset_password_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Reset password")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["edinburgh-stories@armoin.com"])
    end

    EMAIL_PARTS.each do |content_type|
      context "#{content_type}" do
        let(:body) { get_body_for(mail, content_type) }

        it "greets the user" do
          expect(body).to match("Hello #{user.screen_name},")
        end

        it "provides the reset password URL" do
          expect(body).to match(edit_password_reset_url('123abc'))
        end
      end
    end
  end

end
