require 'rails_helper'

feature 'As a user I want to be able to view one of my assets' do
  let(:id)         { "1" }
  let(:asset_data) { AssetFactory.asset_data(id) }
  let(:asset)      { AssetFactory.build_asset(asset_data) }

  before :each do
    allow(Asset).to receive(:find).and_return(asset)
  end

  feature 'So that I can view its details' do
    let(:url)     { "/assets/#{id}" }
    let(:referer) { '/test/refer' }

    before :each do
      Capybara.current_session.driver.header 'Referer', referer
      visit url
    end

    scenario 'fetches the requested asset data' do
      expect(Asset).to have_received(:find).with(id)
    end

    context 'an asset' do
      let(:asset_class) { find('.asset') }

      it 'has a title' do
        expect(asset_class.find('.title')).to have_text("Arthur's Seat")
      end

      it 'has an image' do
        img = asset_class.find('img')
        expect(img['src']).to have_content("test.jpg")
        expect(img['alt']).to have_content("Arthur's Seat")
      end

      it 'has a file_type' do
        expect(asset_class.find('.file_type')).to have_text("image")
      end

      it 'has a description' do
        expect(asset_class.find('.description')).to have_text("Arthur's Seat is the plug of a long extinct volcano.")
      end

      describe 'date' do
        let(:date_text) { asset_class.find('.date').native.text }

        context 'when only a year is given' do
          let(:asset_data) {
            data = AssetFactory.asset_data(id)
            data.delete("month")
            data.delete("day")
            data
          }

          it "has a year" do
            expect(date_text).to eql("\nDates from:\n2014\n")
          end
        end

        context 'when month and year are given' do
          let(:asset_data) {
            data = AssetFactory.asset_data
            data.delete("day")
            data
          }

          it "has a month and a year" do
            expect(date_text).to eql("\nDates from:\nMay 2014\n")
          end
        end

        context 'when day, month and year are given' do
          it "has a day a month and a year" do
            expect(date_text).to eql("\nDates from:\n4th May 2014\n")
          end
        end
      end

      it 'has an attribution' do
        expect(asset_class.find('.attribution')).to have_text("Bobby Tables")
      end
    end

    scenario 'lets me go back to the previous page' do
      expect(page).to have_css("a[href=\"#{referer}\"]", count: 1)
    end
  end
end

