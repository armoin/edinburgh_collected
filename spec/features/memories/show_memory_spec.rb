require 'rails_helper'

feature 'As a user I want to be able to view one of my memories', slow: true do
  let(:user)   { Fabricate(:user, email: 'bobby@example.com') }
  let(:memory) { Fabricate(:photo_memory, user: user) }

  feature 'So that I can view its details' do
    let(:url)     { "/memories/#{memory.id}" }
    let(:referer) { '/test/refer' }

    before :each do
      Capybara.current_session.driver.header 'Referer', referer
      visit url
    end

    context 'a memory' do
      it_behaves_like 'a memory preview'
    end

    scenario 'lets me go back to the previous page' do
      expect(page).to have_link('Back')
    end

    scenario "does not let me edit" do
      expect(page).not_to have_link('Edit')
    end

    scenario "does not let me delete" do
      expect(page).not_to have_link('Delete')
    end
  end
end

