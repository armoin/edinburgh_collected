ENV['HOST'] = if Rails.env.production?
                'http://edinburgh-stories.herokuapp.com/'
              else
                'http://localhost:9393'
              end

