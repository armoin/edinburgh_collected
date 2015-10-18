require 'rails_helper'

feature 'adding a new picture memory', slow: true, js: true do
  before :each do
    Fabricate(:active_user, email: 'bobby@example.com', password: 's3cr3t', password_confirmation: 's3cr3t')
    Fabricate.times(2, :category)
    login('bobby@example.com', 's3cr3t')
    visit '/my/memories/new'
  end

  scenario "when I attach a photo file the image editor is shown" do
    attach_file 'memory[source]', File.join(File.dirname(__FILE__), '../../../fixtures/files/test.jpg')
    expect(page).to have_css('#image-editor')
  end

  scenario 'adding a new photo memory with only the required fields creates it' do
    expect do
      fill_in_required_fields
      click_button 'Save'
    end.to change { Memory.count }.by(1)
  end

  scenario 'attempting to add a photo memory without a photo file shows an error' do
    fill_in_title
    fill_in_description
    select_a_category
    fill_in_year
    click_button 'Save'
    expect(page).to have_css('.help-block', text: 'Please select a photo to upload')
  end

  scenario 'attempting to add a photo memory without a title shows an error' do
    attach_photo
    fill_in_description
    select_a_category
    fill_in_year
    click_button 'Save'
    expect(page).to have_css('.help-block', text: 'Please let us know what title you would like to give this')
  end

  scenario 'attempting to add a photo memory without a description shows an error' do
    attach_photo
    fill_in_title
    select_a_category
    fill_in_year
    click_button 'Save'
    expect(page).to have_css('.help-block', text: 'Please tell us a little bit about this memory')
  end

  scenario 'attempting to add a photo memory without a year shows an error' do
    attach_photo
    fill_in_title
    fill_in_description
    select_a_category
    click_button 'Save'
    expect(page).to have_css('.help-block', text: 'Please tell us when this dates from')
  end

  scenario 'attempting to add a photo memory with a year of 0 shows an error' do
    attach_photo
    fill_in_title
    fill_in_description
    select_a_category
    fill_in 'memory[year]', with: '0'
    click_button 'Save'
    expect(page).to have_css('.help-block', text: 'must be greater than 0')
  end

  scenario 'attempting to add a photo memory with a incorrectly formatted year shows an error' do
    attach_photo
    fill_in_title
    fill_in_description
    select_a_category
    fill_in 'memory[year]', with: '14'
    click_button 'Save'
    expect(page).to have_css('.help-block', text: 'must be in the format YYYY')
  end

  scenario 'attempting to add a photo memory without a category shows an error' do
    attach_photo
    fill_in_title
    fill_in_description
    fill_in_year
    click_button 'Save'
    expect(page).to have_css('.help-block', text: 'Please select at least one')
  end
end

def fill_in_required_fields
  attach_photo
  fill_in_title
  fill_in_description
  select_a_category
  fill_in_year
end

def valid_file
  File.join(File.dirname(__FILE__), '../../../fixtures/files/test.jpg')
end

def attach_photo
  attach_file 'memory[source]', valid_file
end

def fill_in_title
  fill_in 'memory[title]', with: 'A test'
end

def fill_in_year
  fill_in 'memory[year]', with: '2014'
end

def fill_in_description
  fill_in 'memory[description]', with: 'This is a test'
end

def select_a_category
  first(:css, "input[name='memory[category_ids][]']").click
end
