require 'rails_helper'

describe 'my/profile/edit.html.erb' do
  let(:links_count) { 0 }
  let(:links)       { Fabricate.times(links_count, :link) }
  let(:user)        { Fabricate.build(:active_user, id: 123, links: links) }
  let(:is_group)    { false }
  let(:temp_image)  { TempImage.new }

  before :each do
    user.links.build
    allow(user).to receive(:is_group?).and_return(is_group)
    assign(:user, user)
    assign(:temp_image, temp_image)
    render
  end

  describe 'file uploading' do
    it 'has a separate form for uploading the image initially' do
      expect(rendered).to have_css('form#new_temp_image input[type="file"]')
    end
  end

  describe "form fields" do

    it_behaves_like 'a user detail form'

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

    describe 'description' do
      it 'has the label "How would you describe yourself to other users?"' do
        expect(rendered).to have_css('label[for="user_description"]', text: "Bio (a short description of yourself)")
      end

      it "asks the user to give a brief description of themselves" do
        expect(rendered).to have_css('textarea#user_description')
      end

      it "is not required" do
        expect(rendered).not_to have_css('.form-group[aria-required="true"] textarea#user_description')
      end
    end

    describe 'links' do
      context 'when the user has no links yet' do
        let(:links_count) { 0 }

        it "allows the user to add a link" do
          expect(rendered).to have_css('input[type="text"]#user_links_attributes_0_name')
          expect(rendered).to have_css('input[type="text"]#user_links_attributes_0_url')
        end

        it "lets the user add another url" do
          expect(rendered).to have_css('a.add_nested_fields[data-association="links"]', text: 'Add another')
        end

        it "is not required" do
          expect(rendered).not_to have_css('.form-group[aria-required="true"] input[type="text"]#user_links_attributes_0_name')
          expect(rendered).not_to have_css('.form-group[aria-required="true"] input[type="text"]#user_links_attributes_0_url')
        end
      end

      context 'when the user already has links' do
        let(:links_count) { 1 }

        it 'allows the user to edit existing links' do
          links.each.with_index do |link, i|
            expect(rendered).to have_css("input#user_links_attributes_#{i}_name[type=\"text\"][value=\"#{link.name}\"]")
            expect(rendered).to have_css("input#user_links_attributes_#{i}_url[type=\"text\"][value=\"#{link.url}\"]")
          end
        end

        it 'allows the user to delete existing links' do
          links.each.with_index do |link, i|
            expect(rendered).to have_css('a.remove_nested_fields')
          end
        end
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
      expect(rendered).to have_link('Cancel', href: my_profile_path)
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
