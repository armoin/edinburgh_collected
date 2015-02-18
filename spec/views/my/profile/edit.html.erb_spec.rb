require 'rails_helper'

describe 'my/profile/edit.html.erb' do
  let(:user)     { Fabricate.build(:active_user, id: 123) }
  let(:is_group) { false }

  before :each do
    allow(user).to receive(:is_group?).and_return(is_group)
    assign(:user, user)
    render
  end

  describe "form fields" do
    describe 'first_name' do
      it "asks for the user's first name" do
        expect(rendered).to have_css('input[type="text"]#user_first_name')
      end

      it "is required" do
        expect(rendered).to have_css('.form-group[aria-required="true"] input[type="text"]#user_first_name')
      end
    end
    
    describe 'last_name' do
      context 'when the user is not a group' do
        let(:is_group) { false }

        it "asks for the user's last name" do
          expect(rendered).to have_css('input[type="text"]#user_last_name')
        end

        it "is required" do
          expect(rendered).to have_css('.form-group[aria-required="true"] input[type="text"]#user_last_name')
        end
      end

      context 'when the user is a group' do
        let(:is_group) { true }

        it "does not ask for the user's last name" do
          expect(rendered).not_to have_css('input[type="text"]#user_last_name')
        end

        it "is not required" do
          expect(rendered).not_to have_css('.form-group[aria-required="true"] input[type="text"]#user_last_name')
        end
      end
    end
    
    describe 'email' do
      it "asks for the user's email address" do
        expect(rendered).to have_css('input[type="email"]#user_email')
      end

      it "is required" do
        expect(rendered).to have_css('.form-group[aria-required="true"] input[type="email"]#user_email')
      end
    end
    
    describe 'screen_name' do
      it 'has the label "Username"' do
        expect(rendered).to have_css('label[for="user_screen_name"]', text: "Username")
      end

      it "asks for the user's screen name" do
        expect(rendered).to have_css('input[type="text"]#user_screen_name')
      end

      it "is required" do
        expect(rendered).to have_css('.form-group[aria-required="true"] input[type="text"]#user_screen_name')
      end
    end
    
    describe 'password' do
      it "asks for the user's password" do
        expect(rendered).to have_css('input[type="password"]#user_password')
      end

      it "is required" do
        expect(rendered).to have_css('.form-group[aria-required="true"] input[type="password"]#user_password')
      end
    end
    
    describe 'password confirmation' do
      it "asks the user to confirm their password" do
        expect(rendered).to have_css('input[type="password"]#user_password_confirmation')
      end

      it "is required" do
        expect(rendered).to have_css('.form-group[aria-required="true"] input[type="password"]#user_password_confirmation')
      end
    end
  end

  describe "form actions" do
    it "cancels back to the user's profile page" do
      expect(rendered).to have_link('Cancel', my_profile_path)
    end

    describe "submitting" do
      it "submits to the my profile path" do
        expect(rendered).to have_css("form.edit_user[action=\"#{my_profile_path}\"]")
      end

      it "has a submit button" do
        expect(rendered).to have_css('form.edit_user input[type="submit"][value="Save changes"]')
      end
    end
  end
end