if Rails.env == :production
  HOST = 'http://memphis-mock-api.herokuapp.com/'
else
  HOST = 'http://localhost:9393'
end

