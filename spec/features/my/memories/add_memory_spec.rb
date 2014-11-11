require 'rails_helper'

feature 'adding new memories', slow: true, js:true do # REMEMBER: add js:true again if this test is reincluded
  before do
    Fabricate(:active_user, email: 'bobby@example.com', password: 's3cr3t', password_confirmation: 's3cr3t')
    Fabricate(:area)
    Fabricate.times(4, :category)
  end

  let(:memory_attrs) {{
    type:        "Photo",
    title:       "Arthur's Seat",
    year:        "2014",
    description: "Arthur's Seat is the plug of a long extinct volcano."
  }}

  before :each do
    login('bobby@example.com', 's3cr3t')
    visit '/my/memories/new'
  end

  scenario "when I attach an image file the image editor is shown" do
    attach_file :file, File.join(File.dirname(__FILE__), '../../../fixtures/files/test.jpg')
    expect(page).to have_css('#image-editor')
  end

  scenario 'adding a new memory creates it' do
    pre_count = Memory.count
    fill_in_form
    click_button 'Save'
    expect(Memory.count).to eql(pre_count + 1)
  end

  scenario 'clicking Save goes to the My Memories page' do
    fill_in_form
    click_button 'Save'
    expect(current_path).to eq('/my/memories')
  end

  scenario 'clicking Save And Add Another goes to the New page again' do
    fill_in_form
    click_button 'Save And Add Another'
    expect(current_path).to eq('/my/memories/new')
  end
end

def fill_in_form
  select memory_attrs[:type], from: 'memory[type]'
  attach_file :file, File.join(File.dirname(__FILE__), '../../../fixtures/files/test.jpg')
  fill_in 'memory[title]', with: memory_attrs[:title]
  fill_in 'memory[year]', with: memory_attrs[:year]
  fill_in 'memory[description]', with: memory_attrs[:description]
  fill_in 'memory[location]', with: '10 Bath Street'
  find(:css, ".memory_categories label:nth-child(2) input[type='checkbox']").click
  select Area.first.name, from: 'memory[area_id]'
end
