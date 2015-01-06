def login(email, password)
  visit '/signin'
  fill_in 'email', with: email
  fill_in 'password', with: password
  click_button 'Sign in'
end

