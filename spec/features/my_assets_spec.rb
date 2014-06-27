require 'rails_helper'

feature 'As a user I want to be able to manage my assets' do
  feature 'So that I can view my existing assets' do
    scenario 'displays title' do
      visit '/assets'

      expect(page).to have_text('My Assets')
    end
  end
end
