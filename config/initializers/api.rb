ENV['HOST'] = if Rails.env.production?
                'http://memphis-mock-api.herokuapp.com/'
              else
                'http://localhost:9393'
              end

