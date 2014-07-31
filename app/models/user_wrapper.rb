class UserWrapper
  def self.create(attrs)
    response = conn.post '/signup', user: attrs
    response.status == 200
  end

  def self.conn
    Faraday.new(:url => ENV['API_HOST']) do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end
  end
end

