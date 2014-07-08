require 'rails_helper'

describe Asset do
  let(:id) { "986ff7a7b23bed8283dfc4b979f89b99" }
  let(:asset) {
    {
      "title"       => "Arthur's Seat",
      "file_type"   => "img",
      "url"         => "/images/meadows.jpg",
      "alt"         => "Arthur's Seat from the Meadows",
      "description" => "Arthur's Seat is the plug of a long extinct volcano.",
      "width"       => 1280,
      "height"      => 878,
      "resolution"  => 72,
      "device"      => "iphone",
      "length"      => nil,
      "is_readable" => false,
      "updated_at"  => "2014-06-24T09:55:58.874Z",
      "created_at"  => "2014-06-24T09:55:58.874Z",
      "id"          => id,
      "_rev"        => "2-ba56ad0bc1bc907ea02d7afe50563586",
      "type"        => "Asset"
    }
  }
  let(:assets) { [asset] }

  describe 'fetching assets' do
    context 'fetch all' do
      before(:each) do
        allow(AssetWrapper).to receive(:fetchAll) { assets }
      end

      it 'fetches all assets' do
        Asset.all
        expect(AssetWrapper).to have_received(:fetchAll)
      end

      it 'converts them to Assets' do
        assets = Asset.all
        expect(assets.first).to be_a(Asset)
      end
    end

    context 'fetch one' do
      before(:each) do
        allow(AssetWrapper).to receive(:fetch) { asset }
      end

      it 'fetches the requested asset' do
        Asset.find(id)
        expect(AssetWrapper).to have_received(:fetch).with(id)
      end

      it 'converts it into an Asset' do
        asset = Asset.find(id)
        expect(asset).to be_a(Asset)
        expect(asset.id).to eql(id)
      end
    end
  end

  describe "thumb" do
    it "returns an empty string if there is no URL" do
      expect(subject.thumb).to eq('')
    end

    it "returns the thumb version of the URL if there is a URL" do
      subject.url = "test.jpg"
      expect(subject.thumb).to eq('thumb_test.jpg')
    end

    it "takes the path into account" do
      subject.url = "/path/to/test.jpg"
      expect(subject.thumb).to eq('/path/to/thumb_test.jpg')
    end
  end
end
