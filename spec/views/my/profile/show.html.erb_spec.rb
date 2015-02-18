require 'rails_helper'

describe 'my/profile/show.html.erb' do
  let(:is_group) { false }
  let(:user)     { Fabricate.build(:active_user, id: 123, is_group: is_group) }
  

  before :each do
    assign(:user, user)
    render
  end

  it 'shows the avatar' do
    expect(rendered).to have_css('img[src="/assets/avatar.png"]')
  end

  it 'shows the username' do
    expect(rendered).to have_css('h1.title', text: user.screen_name)
  end

  context 'when the user is an individual' do
    let(:is_group) { false }

    it 'shows the first name' do
      expect(rendered).to have_css('p', text: "First name: #{user.first_name}")
    end

    it 'shows the last name' do
      expect(rendered).to have_css('p', text: "Last name: #{user.last_name}")
    end

    it 'does not show the group name' do
      expect(rendered).not_to have_css('p', text: "Group name: #{user.first_name}")
    end
  end

  context 'when the user is a group' do
    let(:is_group) { true }

    it 'does not show the first name' do
      expect(rendered).not_to have_css('p', text: "First name: #{user.first_name}")
    end

    it 'does not show the last name' do
      expect(rendered).not_to have_css('p', text: "Last name: #{user.last_name}")
    end

    it 'shows the group name' do
      expect(rendered).to have_css('p', text: "Description:")
      expect(rendered).to have_css('p', text: user.description)
    end
  end

  it 'shows the description' do
    expect(rendered).to have_css('p', text: "Email: #{user.email}")
  end

  it 'shows the email' do
    expect(rendered).to have_css('p', text: "Email: #{user.email}")
  end  

  it 'has an Edit link' do
    expect(rendered).to have_link('Edit', href: my_profile_edit_path)
  end
end