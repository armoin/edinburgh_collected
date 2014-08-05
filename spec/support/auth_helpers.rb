def auth_token
  '123abc'
end

def login!
  session[:auth_token] = auth_token
end

def logout!
  session[:auth_token] = nil
end

