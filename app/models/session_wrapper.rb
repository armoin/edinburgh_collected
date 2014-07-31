class SessionWrapper
  def self.create(session_attrs)
    response = conn.post '/login', session_attrs
    return nil unless response.status == 200
    JSON.parse(response.body)['token']
  end

  def self.conn
    Faraday.new(:url => ENV['API_HOST']) do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end
  end
end

