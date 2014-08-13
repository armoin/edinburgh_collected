def login(email, password)
  visit '/login'
  fill_in 'email', with: email
  fill_in 'password', with: password
  click_button 'Sign In'
end

