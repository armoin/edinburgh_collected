require 'rails_helper'

feature 'As a user I want to be able to manage my assets' do
  feature 'So that I can view my existing assets' do
    context 'an asset' do
      let(:asset) { find('.asset:first') }

      before :each do
        visit '/assets'
      end

      it 'has a title' do
        expect(asset.find('.title')).to have_text("Arthur's Seat")
      end

      it 'has an image' do
        img = asset.find('img')
        expect(img['src']).to have_content("meadows.jpg")
        expect(img['alt']).to have_content("Arthur's Seat")
      end

      it 'has a link to more details' do
        expect(asset).to have_link('View details')
      end
    end

    scenario 'displays all existing assets' do
      visit '/assets'
      expect(page).to have_css('.asset', count: 5)
    end
  end

  feature 'So that I can add new assets' do
    scenario 'allows the user to add a new asset' do
      visit '/assets'
      click_link('add-asset')
      expect(current_path).to eql('/assets/new')
    end
  end
end
