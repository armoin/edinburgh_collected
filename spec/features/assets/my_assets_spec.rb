require 'rails_helper'

feature 'As a user I want to be able to manage my assets' do
  let(:assets)  { AssetFactory.assets }

  before :each do
    pending 'Need to work out proper end to end testing strategy'
    allow(Asset).to receive(:all).and_return(assets)
  end

  feature 'So that I can view my existing assets' do
    context 'an asset' do
      let(:asset) { find('.asset:first') }

      before :each do
        visit '/assets'
      end

      xscenario 'fetches the requested assets' do
        expect(Asset).to have_received(:all)
      end

      xit 'has a title' do
        expect(asset.find('.title')).to have_text("Arthur's Seat")
      end

      xit 'has an image' do
        img = asset.find('img')
        expect(img['src']).to have_content("test.jpg")
        expect(img['alt']).to have_content("Arthur's Seat")
      end
    end

    xscenario 'displays all existing assets' do
      visit '/assets'
      expect(page).to have_css('.asset', count: 3)
    end
  end

  feature 'So that I can view details on a selected asset' do
    xscenario 'clicking on the View details link' do
      visit '/assets'
      find('.asset[data-id="1"]').click
      expect(current_path).to eql('/assets/1')
    end
  end
end

