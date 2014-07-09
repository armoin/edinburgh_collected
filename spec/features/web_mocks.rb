require 'rspec/core'

RSpec.configure do |config|
  config.before do
    @asset  = AssetFactory.asset_data
    @assets = AssetFactory.assets_data

    # fetchAll
    stub_request(:get, "#{ENV['API_HOST']}/assets").
      to_return(:body => @assets.to_json)

    # fetch
    stub_request(:get, "#{ENV['API_HOST']}/assets/#{@asset[:_id]}").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.0'}).
      to_return(:status => 200, :body => @asset.to_json, :headers => {})

    # create
    stub_request(:post, "#{ENV['API_HOST']}/assets").
      to_return(:body => @asset.to_json)

    # update
    stub_request(:put, "#{ENV['API_HOST']}/assets/#{@asset[:_id]}").
      to_return(:body => @asset.to_json)
  end
end

