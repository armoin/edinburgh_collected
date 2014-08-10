require 'rails_helper'

feature 'As a user I want to be able to view one of my assets', slow: true do
  let(:asset) { Fabricate(:asset) }

  feature 'So that I can view its details' do
    let(:url)     { "/assets/#{asset.id}" }
    let(:referer) { '/test/refer' }

    before :each do
      Capybara.current_session.driver.header 'Referer', referer
      visit url
    end

    context 'an asset' do
      let(:asset_class) { find('.asset') }

      it 'has a title' do
        expect(asset_class.find('.title')).to have_text("A test")
      end

      it 'has an image' do
        img = asset_class.find('img')
        expect(img['src']).to have_content("test.jpg")
        expect(img['alt']).to have_content("A test")
      end

      it 'has a file_type' do
        expect(asset_class.find('.file_type')).to have_text("image")
      end

      it 'has a description' do
        expect(asset_class.find('.description')).to have_text("This is a test.")
      end

      it "has a date" do
        date_text = asset_class.find('.date').native.text
        expect(date_text).to eql("\nDates from:\n4th May 2014\n")
      end

      it 'has an attribution' do
        expect(asset_class.find('.attribution')).to have_text("Bobby Tables")
      end

      it 'has an area' do
        expect(asset_class.find('.area')).to have_text("Portobello")
      end
    end

    scenario 'lets me go back to the previous page' do
      expect(page).to have_css("a[href=\"#{referer}\"]", count: 1)
    end
  end
end

