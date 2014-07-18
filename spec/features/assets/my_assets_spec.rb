require 'rails_helper'

feature 'As a user I want to be able to manage my assets' do
  let(:assets_data)   { AssetFactory.assets_data }
  let(:mock_response) { double('response', status: 200, body: assets_data.to_json) }
  let(:mock_conn)     { double('conn', get: mock_response) }

  before :each do
    allow(Faraday).to receive(:new).and_return(mock_conn)
  end

  feature 'So that I can view my existing assets' do
    context 'an asset' do
      let(:asset) { find('.asset:first') }

      before :each do
        visit '/assets'
      end

      scenario 'fetches the requested asset data' do
        expect(mock_conn).to have_received(:get).with('/assets')
      end

      it 'has a title' do
        expect(asset.find('.title')).to have_text("Arthur's Seat")
      end

      it 'has an image' do
        img = asset.find('img')
        expect(img['src']).to have_content("meadows.jpg")
        expect(img['alt']).to have_content("Arthur's Seat")
      end
    end

    scenario 'displays all existing assets' do
      visit '/assets'
      expect(page).to have_css('.asset', count: 3)
    end
  end

  feature 'So that I can add new assets' do
    scenario 'allows the user to add a new asset' do
      visit '/assets'
      click_link('add-asset')
      expect(current_path).to eql('/assets/new')
    end
  end

  feature 'So that I can view details on a selected asset' do
    scenario 'clicking on the View details link' do
      visit '/assets'
      find('.asset[data-id="986ff7a7b23bed8283dfc4b979f89b99"]').click
      expect(current_path).to eql('/assets/986ff7a7b23bed8283dfc4b979f89b99')
    end
  end
end

