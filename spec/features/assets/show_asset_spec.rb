require 'rails_helper'
require File.join(File.dirname(__FILE__), '..', 'web_mocks')

feature 'As a user I want to be able to view one of my assets' do
  feature 'So that I can view its details' do
    before :each do
      visit '/assets/986ff7a7b23bed8283dfc4b979f89b99'
    end

    context 'an asset' do
      let(:asset) { find('.asset') }

      it 'has a title' do
        expect(asset.find('.title')).to have_text("Arthur's Seat")
      end

      it 'has an image' do
        img = asset.find('img')
        expect(img['src']).to have_content("meadows.jpg")
        expect(img['alt']).to have_content("Arthur's Seat")
      end

      it 'has a file_type' do
        expect(asset.find('.file_type')).to have_text("image")
      end

      it 'has a description' do
        expect(asset.find('.description')).to have_text("Arthur's Seat is the plug of a long extinct volcano.")
      end

      it 'has a date' do
        expect(asset.find('.date')).to have_text("2014-05-04")
      end
    end

    scenario 'lets me go back to the index page' do
      expect(page).to have_css("a[href=\"#{assets_path}\"]", count: 1)
    end
  end
end

