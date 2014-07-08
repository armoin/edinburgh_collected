require 'spec_helper'
require File.join(File.dirname(__FILE__), '../..', 'app', 'models', 'asset_wrapper')

describe AssetWrapper do
  describe 'fetching assets' do
    it 'fetches all assets' do
      expect(AssetWrapper.fetchAll.count).to eql(3)
    end
  end

  describe 'fetching a single asset' do
    let(:id) { "986ff7a7b23bed8283dfc4b979f89b99" }

    it 'fetches the requested asset' do
      expect(AssetWrapper.fetch(id)['id']).to eql(id)
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
      stub_request(:post, "#{ENV['API_HOST']}/assets").
         with(:body => {"asset"=>{"title"=>"A Test"}},
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.0'}).
         to_return(:status => 200, :body => @new_asset.to_json, :headers => {})
      @assets << @new_asset
      stub_request(:get, "#{ENV['API_HOST']}/assets").
        to_return(:body => @assets.to_json)
    end

    it 'creates a new asset' do
      asset = AssetWrapper.create(title: 'A Test')
      expect(asset['title']).to eq('A Test')
      expect(AssetWrapper.fetchAll.count).to eql(4)
    end
  end

  describe 'updating an asset' do
    before :each do
      @id = "72712d823c14dd7982909d5fbbd3cbec"
      @new_title = 'Something else'
      @asset = {
        id: @id,
        title: "A Test"
      }
      @updated_asset = {
        id: @id,
        title: @new_title
      }
      stub_request(:put, "#{ENV['API_HOST']}/assets/#{@id}").
         with(:body => {"asset"=>{"id"=>@id, "title"=>@new_title}},
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.0'}).
         to_return(:status => 200, :body => @updated_asset.to_json, :headers => {})
    end

    it 'updates the asset' do
      asset = Asset.new(@asset)
      asset.title = @new_title
      response = AssetWrapper.update(asset)
      expect(response['title']).to eq(@new_title)
    end
  end
end
