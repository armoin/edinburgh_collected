require 'rails_helper'

feature 'adding new memories', slow: true, js:true do # REMEMBER: add js:true again if this test is reincluded
  before do
    Fabricate(:user, email: 'bobby@example.com')
    Fabricate(:area)
  end

  let(:memory_attrs) {{
    file_type:   "image",
    title:       "Arthur's Seat",
    year:        "2014",
    description: "Arthur's Seat is the plug of a long extinct volcano."
  }}

  scenario 'adding a new memory creates it' do
    pre_count = Memory.count

    visit '/login'
    fill_in 'email', with: 'bobby@example.com'
    fill_in 'password', with: 's3cr3t'
    click_button 'Sign In'

    visit '/my/memories/new'

    select memory_attrs[:file_type], from: 'memory[file_type]'
    attach_file :file, File.join(File.dirname(__FILE__), '../../fixtures/files/test.jpg')
    fill_in 'memory[title]', with: memory_attrs[:title]
    fill_in 'memory[year]', with: memory_attrs[:year]
    fill_in 'memory[description]', with: memory_attrs[:description]
    fill_in 'memory[location]', with: '10 Bath Street'
    select Area.first.name, from: 'memory[area_id]'

    click_button 'Save'

    expect(Memory.count).to eql(pre_count + 1)
    expect(current_path).to eq('/my/memories')
  end
end

