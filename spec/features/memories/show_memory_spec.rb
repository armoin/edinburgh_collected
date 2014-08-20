require 'rails_helper'

feature 'As a user I want to be able to view one of my memories', slow: true do
  let(:user)   { Fabricate(:user, email: 'bobby@example.com') }
  let(:memory) { Fabricate(:memory, user: user) }

  feature 'So that I can view its details' do
    let(:url)     { "/memories/#{memory.id}" }
    let(:referer) { '/test/refer' }

    before :each do
      Capybara.current_session.driver.header 'Referer', referer
      visit url
    end

    context 'a memory' do
      let(:memory_class) { find('.memory') }

      it 'has a title' do
        expect(memory_class.find('.title')).to have_text("A test")
      end

      it 'has an image' do
        img = memory_class.find('img')
        expect(img['src']).to have_content("test.jpg")
        expect(img['alt']).to have_content("A test")
      end

      it 'has a file_type' do
        expect(memory_class.find('.file_type')).to have_text("Image")
      end

      it 'has a description' do
        expect(memory_class.find('.description')).to have_text("This is a test.")
      end

      it "has a date" do
        date_text = memory_class.find('.date').native.text
        expect(date_text).to eql("\nDates from:\n4th May 2014\n")
      end

      it 'has an attribution' do
        expect(memory_class.find('.attribution')).to have_text("Bobby Tables")
      end

      it 'has an address' do
        expect(memory_class.find('.address')).to have_text("Kings Road, Portobello")
      end

      # lat and long come from spec/support/geocoder.rb default stub
      it 'has a longitude' do
        expect(memory_class.find('.longitude')).to have_text("55.9578751")
      end

      # lat and long come from spec/support/geocoder.rb default stub
      it 'has a latitude' do
        expect(memory_class.find('.latitude')).to have_text("-3.1196158")
      end

      it 'has a comma separated list of categories' do
        expect(memory_class.find('.categories')).to have_text(memory.category_list)
      end
    end

    scenario 'lets me go back to the previous page' do
      expect(page).to have_link('Back')
    end

    scenario "does not let me edit" do
      expect(page).not_to have_link('Edit')
    end

    scenario "does not let me delete" do
      expect(page).not_to have_link('Delete')
    end
  end
end

