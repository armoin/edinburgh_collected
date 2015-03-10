require 'rails_helper'

describe 'users/new.html.erb' do
  let(:user)       { User.new }
  let(:temp_image) { TempImage.new }

  before :each do
    user.links.build
    assign(:temp_image, temp_image)
    assign(:user, user)
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

    it_behaves_like 'a user detail form'

    describe 'last_name' do
      it "asks for the user's last name" do
        expect(rendered).to have_css('input[type="text"]#user_last_name')
      end

      it "is required" do
        expect(rendered).to have_css('.form-group[aria-required="true"] input[type="text"]#user_last_name')
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
