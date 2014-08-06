require 'rails_helper'

feature 'As a user I want to be able to view one of my assets' do
  let(:asset_data)    { AssetFactory.asset_data }
  let(:mock_response) { double('response', status: 200, body: asset_data.to_json) }
  let(:mock_conn)     { double('conn', get: mock_response) }

  before :each do
    allow(Faraday).to receive(:new).and_return(mock_conn)
  end

  feature 'So that I can view its details' do
    let(:url)     { '/assets/986ff7a7b23bed8283dfc4b979f89b99' }
    let(:referer) { '/test/refer' }

    before :each do
      Capybara.current_session.driver.header 'Referer', referer
      visit url
    end

    scenario 'fetches the requested asset data' do
      expect(mock_conn).to have_received(:get).with(url)
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

      describe 'date' do
        let(:date_text) { asset.find('.date').native.text }

        context 'when only a year is given' do
          let(:asset_data) {
            data = AssetFactory.asset_data
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
        expect(asset.find('.attribution')).to have_text("Bobby Tables")
      end
    end

    scenario 'lets me go back to the previous page' do
      expect(page).to have_css("a[href=\"#{referer}\"]", count: 1)
    end
  end
end

