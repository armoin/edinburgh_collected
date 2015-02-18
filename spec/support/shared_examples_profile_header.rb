require 'rails_helper'

RSpec.shared_examples 'a profile headed page' do
  before :each do
    render
  end

  describe 'profile header' do
    it 'displays the profile for the requested user' do
      expect(rendered).to have_css('#profileHeader')
    end

    context 'when the user is not logged in' do
      let(:current_user) { nil }

      it "does not contain a link to the user's profile" do
        expect(rendered).not_to have_link('View your profile', href: my_profile_path)
      end

      it "displays the requested user's avatar" do
        expect(rendered).to have_css('img[src="/assets/avatar.png"]')
      end

      it "displays the requested user's username" do
        expect(rendered).to have_css('h1.title', text: requested_user.screen_name)
      end

      it "does not display a link to edit the user's profile" do
        expect(rendered).not_to have_link('Edit', href: my_profile_edit_path)
      end

      it "displays the requested user's description" do
        expect(rendered).to have_css('p.sub', text: requested_user.description)
      end
    end

    context 'when the user is logged in' do
      context 'and is also the requested user' do
        let(:current_user) { requested_user }

        it "contains a link to the user's profile" do
          expect(rendered).to have_link('View your profile', href: my_profile_path)
        end

        it "displays the requested user's avatar" do
          expect(rendered).to have_css('img[src="/assets/avatar.png"]')
        end

        it "displays the requested user's username" do
          expect(rendered).to have_css('h1.title', text: requested_user.screen_name)
        end

        it "displays a link to edit the user's profile" do
          expect(rendered).to have_link('Edit', href: my_profile_edit_path)
        end

        it "does not display the requested user's description" do
          expect(rendered).not_to have_css('p.sub', text: requested_user.description)
        end
      end

      context 'and is not the requested user' do
        let(:current_user) { Fabricate.build(:active_user, id: 456) }

        it "does not contain a link to the user's profile" do
          expect(rendered).not_to have_link('View your profile', href: my_profile_path)
        end

        it "displays the requested user's avatar" do
          expect(rendered).to have_css('img[src="/assets/avatar.png"]')
        end

        it "displays the requested user's username" do
          expect(rendered).to have_css('h1.title', text: requested_user.screen_name)
        end

        it "does not display a link to edit the user's profile" do
          expect(rendered).not_to have_link('Edit', href: my_profile_edit_path)
        end

        it "displays the requested user's description" do
          expect(rendered).to have_css('p.sub', text: requested_user.description)
        end
      end
    end
  end
end