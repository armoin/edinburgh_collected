require 'rspec/core'

RSpec.configure do |config|
  config.before do
    @asset  = AssetFactory.asset_data
    @assets = AssetFactory.assets_data

    stub_request(:get, "#{ENV['API_HOST']}/assets").
      to_return(:body => @assets.to_json)
    stub_request(:get, "#{ENV['API_HOST']}/assets/986ff7a7b23bed8283dfc4b979f89b99").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.0'}).
      to_return(:status => 200, :body => @asset.to_json, :headers => {})
  end
end

