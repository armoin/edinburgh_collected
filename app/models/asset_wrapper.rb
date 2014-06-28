class AssetWrapper
  def self.fetchAll
    conn = Faraday.new(:url => 'http://localhost:9393') do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end

    ## GET ##
    response = conn.get '/assets'
    JSON.parse(response.body)
  end

  def self.create(attrs)
    conn = Faraday.new(:url => 'http://localhost:9393') do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end

    ## POST ##
    response = conn.post '/assets', asset: attrs
    JSON.parse(response.body)
  end
end
