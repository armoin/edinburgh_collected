class AssetWrapper
  def self.fetchAll
    response = conn.get '/assets'
    assets = JSON.parse(response.body)
    assets
  end

  def self.fetch(id)
    response = conn.get "/assets/#{id}"
    raise 'Asset not found' if response.status == 404
    attrs = JSON.parse(response.body)
    attrs
  end

  def self.create(asset)
    response = conn.post '/assets', asset: asset.instance_values
    attrs = JSON.parse(response.body)
    attrs['id']
  end

  def self.update(asset)
    response = conn.put "/assets/#{asset.id}", asset: asset.instance_values
    attrs = JSON.parse(response.body)
    attrs
  end

  def self.conn
    Faraday.new(:url => ENV['API_HOST']) do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end
  end
end
