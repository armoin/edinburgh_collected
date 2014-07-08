class AssetWrapper
  def self.fetchAll
    response = conn.get '/assets'
    parse(response.body)
  end

  def self.fetch(id)
    response = conn.get "/assets/#{id}"
    raise 'Asset not found' if response.status == 404
    parse(response.body)
  end

  def self.create(attrs)
    response = conn.post '/assets', asset: attrs
    parse(response.body)
  end

  def self.update(asset)
    response = conn.put "/assets/#{asset.id}", asset: asset.instance_values
    parse(response.body)
  end

  def self.parse(body)
    attrs = JSON.parse(body)
    if attrs.is_a?(Array)
      attrs.map!{|a| a['id'] = a['_id']; a}
    else
      attrs['id'] = attrs['_id']
    end
    attrs
  end

  def self.conn
    Faraday.new(:url => ENV['API_HOST']) do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end
  end
end
