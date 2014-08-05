class AssetWrapper
  def self.fetchAll
    response = conn.get '/assets'
    assets = JSON.parse(response.body)
    assets
  end

  def self.fetchUser(auth_token)
    response = authenticated_conn(auth_token).get '/assets/user'
    raise 'Invalid authentication token' if response.status == 400
    raise 'Forbidden' if response.status == 403
    assets = JSON.parse(response.body)
    assets
  end

  def self.fetch(id)
    response = conn.get "/assets/#{id}"
    raise 'Asset not found' if response.status == 404
    attrs = JSON.parse(response.body)
    attrs
  end

  def self.create(asset, auth_token)
    response = authenticated_conn(auth_token).post '/assets', asset: asset.instance_values
    attrs = JSON.parse(response.body)
    attrs['id']
  end

  def self.conn
    Faraday.new(:url => ENV['API_HOST']) do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end
  end

  def self.authenticated_conn(auth_token)
    authenticated_conn = conn
    authenticated_conn.token_auth(auth_token)
    authenticated_conn
  end
end
