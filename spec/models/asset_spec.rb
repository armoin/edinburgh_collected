require 'rails_helper'

describe Asset do
  let(:id) { "986ff7a7b23bed8283dfc4b979f89b99" }
  let(:asset_data) {
    {
      "title"       => "Arthur's Seat",
      "file_type"   => "img",
      "url"         => "/images/meadows.jpg",
      "description" => "Arthur's Seat is the plug of a long extinct volcano.",
      "updated_at"  => "2014-06-24T09:55:58.874Z",
      "created_at"  => "2014-06-24T09:55:58.874Z",
      "id"          => id
    }
  }
  let(:assets) { [asset_data] }

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
        allow(AssetWrapper).to receive(:fetch) { asset_data }
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

  describe "creating" do
    let(:attrs) { { } }
    let(:mock_source) { double('source', store!: true, url: 'thingy') }
    let(:mock_asset)  { double('asset', source: mock_source, 'url=' => true) }

    before :each do
      allow_any_instance_of(Asset).to receive(:source).and_return(mock_source)
      allow(Asset).to receive(:new).and_return(mock_asset)
      allow(AssetWrapper).to receive(:create)
      Asset.create(attrs)
    end

    it "builds a new asset" do
      expect(Asset).to have_received(:new)
    end

    context "when a file is attached" do
      let(:attrs) { { file: "test.jpg" } }

      it "stores the file" do
        expect(mock_source).to have_received(:store!).with('test.jpg')
      end

      it "attaches the URL to the asset" do
        expect(mock_asset).to have_received(:url=).with('thingy')
      end
    end

    context "when a file is not attached" do
      it "does not try to store a file" do
        expect(mock_source).not_to have_received(:store!)
      end

      it "does not attach a URL to the asset" do
        expect(mock_asset).not_to have_received(:url=)
      end
    end

    it "creates the file" do
      expect(AssetWrapper).to have_received(:create).with(mock_asset)
    end
  end

  it "allows instantiation with attributes" do
    asset = Asset.new(asset_data)
    attrs = %w(id title file_type url description created_at updated_at)
    attrs.each do |attr|
      expect(asset.send(attr)).to eql(asset_data[attr])
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
