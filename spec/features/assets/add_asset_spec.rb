require 'rails_helper'

feature 'adding new assets', slow: true, js:true do # REMEMBER: add js:true again if this test is reincluded
  before do
    Fabricate(:user, email: 'bobby@example.com')
    Fabricate(:area)
  end

  let(:asset_attrs) {{
    file_type:   "image",
    title:       "Arthur's Seat",
    year:        "2014",
    description: "Arthur's Seat is the plug of a long extinct volcano."
  }}

  scenario 'adding a new asset creates it' do
    pre_count = Asset.count

    visit '/login'
    fill_in 'email', with: 'bobby@example.com'
    fill_in 'password', with: 's3cr3t'
    click_button 'Sign In'

    visit '/workspace/assets/new'

    select asset_attrs[:file_type], from: 'asset[file_type]'
    attach_file :file, File.join(File.dirname(__FILE__), '../../fixtures/files/test.jpg')
    fill_in 'asset[title]', with: asset_attrs[:title]
    fill_in 'asset[year]', with: asset_attrs[:year]
    fill_in 'asset[description]', with: asset_attrs[:description]
    select Area.first.name, from: 'asset[area_id]'

    click_button 'Save'

    expect(Asset.count).to eql(pre_count + 1)
    expect(current_path).to eq('/workspace/assets')
  end
end

