require 'rails_helper'

feature 'As a user I want to be able to view one of my memories', slow: true do
  let!(:user)   { Fabricate(:active_user, email: 'bobby@example.com') }
  let!(:memory) { Fabricate(:photo_memory, user: user) }
  let(:url) { "/my/memories/#{memory.id}" }

  feature 'So that I can view its details' do
    context 'when not logged in' do
      it 'asks me to sign in' do
        visit url
        expect(page).to have_content("Please sign in")
      end
    end

    context 'when logged in' do
      before :each do
        login('bobby@example.com', 's3cr3t')
        visit url
      end

      context "and memory is not mine" do
        let!(:memory) { Fabricate(:photo_memory) }

        it 'tells me the memory cannot be found' do
          visit url
          expect(page).to have_content("Not found")
        end
      end

      context 'and memory is mine' do
        it_behaves_like 'a memory preview'
      end

      scenario 'lets me go back to the previous page' do
        expect(page).to have_link('Back')
      end

      scenario "let's me edit" do
        expect(page).to have_link('Edit')
      end

      scenario "let's me delete" do
        expect(page).to have_link('Delete')
      end

      scenario "let's me add it to a scrapbook" do
        expect(page).to have_link('Add to a scrapbook +')
      end
    end
  end
end

