require 'rspec/core'

RSpec.configure do |config|
  config.before do
    @asset  = AssetFactory.asset_data
    @assets = AssetFactory.assets_data

    # fetchAll
    stub_request(:get, "#{ENV['API_HOST']}/assets").
      to_return(:status => 200, :body => @assets.to_json, :headers => {})

    # fetch
    stub_request(:get, "#{ENV['API_HOST']}/assets/#{@asset[:_id]}").
      to_return(:status => 200, :body => @asset.to_json, :headers => {})
  end
end

