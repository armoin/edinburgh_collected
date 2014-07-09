require 'rails_helper'
require File.join(File.dirname(__FILE__), '..', 'web_mocks')

feature 'adding new assets' do
  scenario 'adding a new asset adds it to the users assets' do
    visit '/assets/new'

    select 'image', from: 'asset[file_type]'
    attach_file :file, File.join(File.dirname(__FILE__), '../../fixtures/files/test.jpg')
    fill_in 'asset[title]', with: 'A Test'
    fill_in 'asset[date]', with: '2014-07-07'
    fill_in 'asset[description]', with: 'Oh the heady days of testing.'

    click_button 'Save'

    expect(current_path).to eq('/assets')
  end
end

