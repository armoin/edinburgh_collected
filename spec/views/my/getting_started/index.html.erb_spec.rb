require 'rails_helper'

describe 'my/getting_started/index.html.erb' do
  let(:current_user)         { Fabricate.build(:active_user, id: 123) }
  let(:show_getting_started) { true }
  let(:has_profile)          { false }
  let(:has_memories)         { false }
  let(:has_scrapbooks)       { false }

  before :each do
    allow(view).to receive(:current_user).and_return(current_user)

    allow(current_user).to receive(:show_getting_started?).and_return(show_getting_started)
    allow(current_user).to receive(:has_profile?).and_return(has_profile)
    allow(current_user).to receive(:has_memories?).and_return(has_memories)
    allow(current_user).to receive(:has_scrapbooks?).and_return(has_scrapbooks)

    render
  end

  it 'welcomes the user' do
    expect(rendered).to have_css('h1', text: "Welcome #{current_user.screen_name}")
  end

  describe 'protip on finding the getting started page again' do
    context 'when the user should still see the getting started page at sign in' do
      let(:show_getting_started) { true }

      it "shows the protip" do
        expect(rendered).to have_css('.protip')
      end
    end

    context 'when the user should not still see the getting started page at sign in' do
      let(:show_getting_started) { false }

      it "does not show the protip" do
        expect(rendered).not_to have_css('.protip')
      end
    end
  end

  describe 'the profile step' do
    context 'when the user has not completed the step' do
      let(:has_profile) { false }

      it "is not checked" do
        expect(rendered).to have_css('#profile-step .step:not(.checked)')
      end

      it "is a link to the user's Edit profile page" do
        expect(rendered).to have_link("1. Fill out your profile", href: my_profile_edit_path)
      end

      it 'shows the "Fill in your profile" instructions' do
        expect(rendered).to have_css('#profile-step .inner.bottom p', text: "Add a bio and profile picture.")
      end
    end

    context 'when the user has completed the step' do
      let(:has_profile) { true }

      it "is checked" do
        expect(rendered).to have_css('#profile-step .step.checked')
      end

      it "is a link to the user's View profile page" do
        expect(rendered).to have_link("1. Fill out your profile", href: my_profile_path)
      end

      it 'shows the "That\'s your profile ready" instructions' do
        expect(rendered).to have_css('#profile-step .inner.bottom p', text: "Done!")
      end
    end
  end

  describe 'the memories step' do
    context 'when the user has not completed the step' do
      let(:has_memories) { false }

      it "is not checked" do
        expect(rendered).to have_css('#memories-step .step:not(.checked)')
      end

      it "is a link to the Add memory page" do
        expect(rendered).to have_link("2. Upload your first memory", href: add_memory_my_memories_path)
      end

      it 'shows the "Upload your first memory" instructions' do
        expect(rendered).to have_css('#memories-step .inner.bottom p', text: "Start uploading your memories")
      end
    end

    context 'when the user has completed the step' do
      let(:has_memories) { true }

      it "is checked" do
        expect(rendered).to have_css('#memories-step .step.checked')
      end

      it "is a link to the user's My memories page" do
        expect(rendered).to have_link("2. Upload your first memory", href: my_memories_path)
      end

      it 'shows the "Now that you\'ve added your first memory" instructions' do
        expect(rendered).to have_css('#memories-step .inner.bottom p', text: "Done!")
      end
    end
  end

  describe 'the scrapbooks step' do
    context 'when the user has not completed the step' do
      let(:has_scrapbooks) { false }

      it "is not checked" do
        expect(rendered).to have_css('#scrapbooks-step .step:not(.checked)')
      end

      it "is a link to the Create scrapbook page" do
        expect(rendered).to have_link("3. Create your first scrapbook", href: new_my_scrapbook_path)
      end

      it 'shows the "Create your first scrapbook" instructions' do
        expect(rendered).to have_css('#scrapbooks-step .inner.bottom p', text: "Create a scrapbook and start saving your favourites")
      end
    end

    context 'when the user has completed the step' do
      let(:has_scrapbooks) { true }

      it "is checked" do
        expect(rendered).to have_css('#scrapbooks-step .step.checked')
      end

      it "is a link to the user's My scrapbooks page" do
        expect(rendered).to have_link("3. Create your first scrapbook", href: my_scrapbooks_path)
      end

      it 'shows the "Now that you\'ve created your first scrapbook" instructions' do
        expect(rendered).to have_css('#scrapbooks-step .inner.bottom p', text: "Done!")
      end
    end
  end

  describe 'the hide this button' do
    context 'when the user should still see the getting started page at sign in' do
      let(:show_getting_started) { true }

      it "shows the hide this button" do
        expect(rendered).to have_css('input[type="submit"].hideThis')
      end
    end

    context 'when the user should not still see the getting started page at sign in' do
      let(:show_getting_started) { false }

      it "does not show the hide this button" do
        expect(rendered).not_to have_css('input[type="submit"].hideThis')
      end
    end
  end
end
