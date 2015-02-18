require 'rails_helper'

describe 'users/new.html.erb' do
  before :each do
    assign(:user, User.new)
    render
  end

  describe 'form fields' do
    describe 'is_group' do
      it 'has the label "How would you describe yourself to other users?"' do
        expect(rendered).to have_css('label[for="user_is_group"]', text: "Who is this account for?")
      end

      it "lets the user to add an account for an indivdual or for a group" do
        expect(rendered).to have_css('input[type="radio"]#user_is_group_true')
        expect(rendered).to have_css('input[type="radio"]#user_is_group_false')
      end
    end
    
    describe 'first_name' do
      it "asks for the user's first name" do
        expect(rendered).to have_css('input[type="text"]#user_first_name')
      end

      it "is required" do
        expect(rendered).to have_css('.form-group[aria-required="true"] input[type="text"]#user_first_name')
      end
    end
    
    describe 'last_name' do
      it "asks for the user's last name" do
        expect(rendered).to have_css('input[type="text"]#user_last_name')
      end

      it "is required" do
        expect(rendered).to have_css('.form-group[aria-required="true"] input[type="text"]#user_last_name')
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
    
    describe 'accepting the T&Cs' do
      it "asks the user to accept the T&Cs" do
        expect(rendered).to have_css('input[type="checkbox"]#user_accepted_t_and_c')
      end

      it "is required" do
        expect(rendered).to have_css('.form-group[aria-required="true"] input[type="checkbox"]#user_accepted_t_and_c')
      end
    end
  end

  describe "form actions" do
    it "cancels back to the home page" do
      expect(rendered).to have_link('Cancel', root_path)
    end

    describe "submitting" do
      it "submits to the signup path" do
        expect(rendered).to have_css("form#new_user[action=\"#{signup_path}\"]")
      end

      it "has a submit button" do
        expect(rendered).to have_css('form#new_user input[type="submit"][value="Sign up"]')
      end
    end
  end
end