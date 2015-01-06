require 'rails_helper'

feature 'As a user who wants to add content to the site' do
  scenario 'I can sign up for an individual account', js:true do
    visit '/signup'

    choose  'An individual'
    fill_in 'First name',                 with: 'Bobby'
    fill_in 'Last name',                  with: 'Tables'
    fill_in 'Email',                      with: 'bobby@example.com'
    fill_in 'Username',                   with: 'Bob'
    fill_in 'user_password',              with: 's3cr3t'
    fill_in 'user_password_confirmation', with: 's3cr3t'
    check   'user_accepted_t_and_c'

    click_button 'Sign up'

    user = User.find_by_email('bobby@example.com')
    expect(user.first_name).to eql('Bobby')
    expect(user.last_name).to eql('Tables')
    expect(user.screen_name).to eql('Bob')
    expect(user.email).to eql('bobby@example.com')
    expect(user.is_group).to eql(false)

    expect(current_path).to eql(root_path)
  end

  scenario 'I can sign up for a group account', js:true do
    visit '/signup'

    choose  'A group'
    fill_in 'Group name',                 with: 'Fight Club'
    fill_in 'Email',                      with: 'fight_club@example.com'
    fill_in 'Username',                   with: 'Fight Club'
    fill_in 'user_password',              with: 's3cr3t'
    fill_in 'user_password_confirmation', with: 's3cr3t'
    check   'user_accepted_t_and_c'

    click_button 'Sign up'

    user = User.find_by_email('fight_club@example.com')
    expect(user.first_name).to eql('Fight Club')
    expect(user.screen_name).to eql('Fight Club')
    expect(user.email).to eql('fight_club@example.com')
    expect(user.is_group).to eql(true)

    expect(current_path).to eql(root_path)
  end

  context 'with an existing user' do
    let!(:user) {
      Fabricate(:active_user,
                email: 'bobby@example.com',
                screen_name: 'bob',
                password: 's3cr3t',
                password_confirmation: 's3cr3t')
    }

    scenario "I can sign in to my account" do
      visit '/signin'

      fill_in 'Email',    with: 'bobby@example.com'
      fill_in 'Password', with: 's3cr3t'

      click_button 'Sign in'

      expect(current_path).to eql(my_memories_path)
      expect(page).to have_content('My account')
    end

    scenario "I can sign in to my account with a capitalised email address" do
      visit '/signin'

      fill_in 'Email',    with: 'Bobby@example.com'
      fill_in 'Password', with: 's3cr3t'

      click_button 'Sign in'

      expect(current_path).to eql(my_memories_path)
      expect(page).to have_content('My account')
    end

    scenario "I can view my details" do
      login('bobby@example.com', 's3cr3t')

      visit '/'

      click_link 'My account' #user.screen_name

      expect(current_path).to eql(my_profile_path)
      expect(page).to have_content("First name: #{user.first_name}")
      expect(page).to have_content("Last name: #{user.last_name}")
      expect(page).to have_content("Email: #{user.email}")
    end

    scenario "I can change my details" do
      login('bobby@example.com', 's3cr3t')

      visit '/my/profile'

      click_link 'Edit'

      expect(current_path).to eql(my_profile_edit_path)

      fill_in 'First name', with: 'Bobby'

      click_button 'Save changes'

      expect(user.reload.first_name).to eql('Bobby')
    end
  end
end
