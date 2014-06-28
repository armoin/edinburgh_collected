require 'spec_helper'

describe 'AssetWrapper' do
  describe 'fetching assets' do
    it 'fetches all assets' do
      expect(AssetWrapper.fetchAll.count).to eql(5)
    end
  end

  describe 'creating an asset' do
    before :each do
      @new_asset = {
        title: "A Test",
        file_type: nil,
        url: nil,
        alt: nil,
        description: nil,
        width: nil,
        height: nil,
        resolution: nil,
        device: nil,
        length: nil,
        is_readable: false,
        updated_at: nil,
        created_at: nil,
        _id: "72712d823c14dd7982909d5fbbd3cbec",
        _rev: "1-1bce9054a6a74f7fd2d7ed2c5f2b855e",
        type: "Asset"
      }
      stub_request(:post, "http://localhost:9393/assets").
         with(:body => {"asset"=>{"title"=>"A Test"}},
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.0'}).
         to_return(:status => 200, :body => @new_asset.to_json, :headers => {})
      @sample_request << @new_asset
      stub_request(:get, "http://localhost:9393/assets").
        to_return(:body => @sample_request.to_json)
    end

    it 'creates a new asset' do
      asset = AssetWrapper.create(title: 'A Test')
      expect(asset['title']).to eq('A Test')
      expect(AssetWrapper.fetchAll.count).to eql(6)
    end
  end
end
