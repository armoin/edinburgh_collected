require 'rails_helper'

feature 'As a user I want to be able to create a scrapbook', js:true do
  let!(:user)   { Fabricate(:active_user, email: 'bobby@example.com') }
  let!(:memory) { Fabricate(:photo_memory, user: user) }
  let(:url) { "/my/memories/#{memory.id}" }

  before :each do
    login('bobby@example.com', 's3cr3t')
    visit url
  end

  feature 'adding a memory to a scrapbook' do
    before :each do
      Fabricate.times(1, :scrapbook, user: user)
      click_link 'Add to scrapbook +'
      @add_modal = find('#add-to-scrapbook-modal')
    end

    scenario 'includes the memory title in the header' do
      expect(@add_modal).to have_css('.modal-title', text: "Add #{memory.title} to a scrapbook")
    end

    xscenario 'allows the user to select an existing scrapbook' do
      expect(@add_modal).to have_css('.scrapbooks .scrapbook', count: 1)
    end

    scenario 'allows the user to create a new scrapbook' do
      expect(@add_modal).to have_css('button#create-scrapbook')
    end

    scenario 'allows the user to cancel action' do
      expect(@add_modal).to have_css('button.cancel')
    end

    scenario 'allows the user to add the memory to a scrapbook' do
      expect(@add_modal).to have_css('button.save')
    end

    feature 'on cancel' do
      before :each do
        click_button 'Cancel'
      end

      scenario 'closes the Add To Scrapbook modal' do
        expect(page).not_to have_css('#add-to-scrapbook-modal')
      end

      scenario 'does not show the Create Scrapbook modal' do
        expect(page).not_to have_css('#create-scrapbook-modal')
      end
    end
  end

  feature 'creating a new scrapbook' do
    before :each do
      click_link 'Add to scrapbook +'
      click_button 'Create a new scrapbook'
      @create_modal = find('#create-scrapbook-modal')
    end

    scenario "lets the user give the scrapbook a title" do
      expect(@create_modal).to have_css('form#create-scrapbook input#scrapbook_title')
    end

    scenario "lets the user give the scrapbook a description" do
      expect(@create_modal).to have_css('form#create-scrapbook textarea#scrapbook_description')
    end

    scenario 'allows the user to cancel action' do
      expect(@create_modal).to have_css('form#create-scrapbook #cancel-create-scrapbook')
    end

    scenario 'allows the user to create a new scrapbook' do
      expect(@create_modal).to have_css('form#create-scrapbook button.save')
    end

    feature 'on cancel' do
      before :each do
        click_button 'cancel-create-scrapbook'
      end

      scenario 'closes the Create Scrapbook modal' do
        expect(page).not_to have_css('#create-scrapbook-modal')
      end
    end
  end
end

