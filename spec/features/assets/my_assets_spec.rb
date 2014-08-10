require 'rails_helper'

feature 'As a user I want to be able to manage my assets', slow: true do
  let(:user)    { Fabricate(:user) }
  let(:area)    { Fabricate(:area) }
  let(:assets)  { Fabricate.times(3, :asset, user: user, area: area) }

  before :each do
    allow(Asset).to receive(:all).and_return(assets)
  end

  feature 'So that I can view my existing assets' do
    context 'an asset' do
      let(:asset) { find('.asset:first') }

      before :each do
        visit '/assets'
      end

      scenario 'fetches the requested assets' do
        expect(Asset).to have_received(:all)
      end

      it 'has a title' do
        expect(asset.find('.title')).to have_text("A test")
      end

      it 'has an image' do
        img = asset.find('img')
        expect(img['src']).to have_content("test.jpg")
        expect(img['alt']).to have_content("A test")
      end
    end

    scenario 'displays all existing assets' do
      visit '/assets'
      expect(page).to have_css('.asset', count: 3)
    end
  end

  feature 'So that I can view details on a selected asset' do
    scenario 'clicking on the View details link' do
      visit '/assets'
      find('.asset[data-id="1"]').click
      expect(current_path).to eql('/assets/1')
    end
  end
end

