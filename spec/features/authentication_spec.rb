require 'rails_helper'

feature 'As a user who wants to add content to the site' do
  scenario 'I can sign up for an account without a screen name' do
    visit '/signup'

    fill_in 'First name',                    with: 'Bobby'
    fill_in 'Last name',                     with: 'Tables'
    fill_in 'Email',                         with: 'bobby@example.com'
    fill_in 'user_password',                 with: 's3cr3t'
    fill_in 'user_password_confirmation',    with: 's3cr3t'

    click_button 'Sign Up'

    user = User.last
    expect(user.first_name).to eql('Bobby')
    expect(user.last_name).to eql('Tables')
    expect(user.email).to eql('bobby@example.com')

    expect(current_path).to eql(login_path)
  end

  scenario 'I can sign up for an account with a screen name' do
    visit '/signup'

    fill_in 'First name',                    with: 'Bobby'
    fill_in 'Last name',                     with: 'Tables'
    fill_in 'What should we call you?',      with: 'Bob'
    fill_in 'Email',                         with: 'bobby@example.com'
    fill_in 'user_password',                 with: 's3cr3t'
    fill_in 'user_password_confirmation',    with: 's3cr3t'

    click_button 'Sign Up'

    user = User.last
    expect(user.first_name).to eql('Bobby')
    expect(user.last_name).to eql('Tables')
    expect(user.screen_name).to eql('Bob')
    expect(user.email).to eql('bobby@example.com')

    expect(current_path).to eql(login_path)
  end

  scenario "I can sign in to my account" do
    visit '/signup'

    fill_in 'First name',                    with: 'Bobby'
    fill_in 'Last name',                     with: 'Tables'
    fill_in 'What should we call you?',      with: 'Bob'
    fill_in 'Email',                         with: 'bobby@example.com'
    fill_in 'user_password',                 with: 's3cr3t'
    fill_in 'user_password_confirmation',    with: 's3cr3t'

    click_button 'Sign Up'

    expect(current_path).to eql(login_path)

    fill_in 'Email',    with: 'bobby@example.com'
    fill_in 'Password', with: 's3cr3t'

    click_button 'Sign In'

    expect(current_path).to eql(root_path)
    expect(page).to have_content('Welcome, Bob')
  end
end
