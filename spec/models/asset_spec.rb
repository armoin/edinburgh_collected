require 'spec_helper'

describe 'Asset' do
  describe 'fetching assets' do
    let(:assets) {
      [
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
          "_id"         => "986ff7a7b23bed8283dfc4b979f89b99",
          "_rev"        => "2-ba56ad0bc1bc907ea02d7afe50563586",
          "type"        => "Asset"
        }
      ]
    }

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

  describe "id" do
    it "allows the getting/setting of the id" do
      expect(Asset.new(id: 123).id).to eql(123)
    end
  end

  describe "thumb" do
    subject { Asset.new }

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
