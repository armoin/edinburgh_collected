class AssetWrapper
  def self.fetchAll
    response = conn.get '/assets'
    assets = JSON.parse(response.body)
    assets.map!{ |attrs| parse(attrs) }
  end

  def self.fetch(id)
    response = conn.get "/assets/#{id}"
    raise 'Asset not found' if response.status == 404
    attrs = JSON.parse(response.body)
    parse(attrs)
  end

  def self.create(asset)
    response = conn.post '/assets', asset: asset.instance_values
    attrs = JSON.parse(response.body)
    parse(attrs)
  end

  def self.update(asset)
    response = conn.put "/assets/#{asset.id}", asset: asset.instance_values
    attrs = JSON.parse(response.body)
    parse(attrs)
  end

  def self.parse(attrs)
    attrs['id'] = attrs.delete('_id')
    attrs.delete('_rev')
    attrs.delete('type')
    attrs
  end

  def self.conn
    Faraday.new(:url => ENV['API_HOST']) do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end
  end
end
