require 'rails_helper'

feature 'As a user who wants to add content to the site' do
  scenario 'I can sign up for an account' do
    visit '/signup'

    fill_in 'First name',                    with: 'Bobby'
    fill_in 'Last name',                     with: 'Tables'
    fill_in 'What should we call you?',      with: 'Bob'
    fill_in 'Email',                         with: 'bobby@example.com'
    fill_in 'user_password',                 with: 's3cr3t'
    fill_in 'user_password_confirmation',    with: 's3cr3t'

    click_button 'Sign Up'

    user = User.find_by(email: 'bobby@example.com')
    expect(user.first_name).to eql('Bobby')
    expect(user.last_name).to eql('Tables')
    expect(user.screen_name).to eql('Bob')
    expect(user.email).to eql('bobby@example.com')

    expect(current_path).to eql(root_path)
  end

  scenario "I can sign in to my account" do
    Fabricate(:active_user, email: 'bobby@example.com', screen_name: 'bob')

    visit '/login'

    fill_in 'Email',    with: 'bobby@example.com'
    fill_in 'Password', with: 's3cr3t'

    click_button 'Sign In'

    expect(current_path).to eql(root_path)
    expect(page).to have_content('Welcome, bob')
  end
end
