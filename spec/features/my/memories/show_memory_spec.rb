require 'rails_helper'

feature 'As a user I want to be able to view one of my memories', slow: true do
  let!(:user)   { Fabricate(:user, email: 'bobby@example.com') }
  let!(:memory) { Fabricate(:memory, user: user) }
  let(:url) { "/my/memories/#{memory.id}" }

  feature 'So that I can view its details' do
    context 'when not logged in' do
      it 'asks me to login' do
        visit url
        expect(page).to have_content("Please login")
      end
    end

    context 'when logged in' do
      before :each do
        login('bobby@example.com', 's3cr3t')
        visit url
      end

      context "and memory is not mine" do
        let!(:memory) { Fabricate(:memory) }

        it 'tells me the memory cannot be found' do
          visit url
          expect(page).to have_content("Not found")
        end
      end

      context 'and memory is mine' do
        let(:memory_class) { find('.memory') }

        it 'has a title' do
          expect(memory_class.find('.title')).to have_text("A test")
        end

        it 'has an image' do
          img = memory_class.find('img')
          expect(img['src']).to have_content("test.jpg")
          expect(img['alt']).to have_content("A test")
        end

        it 'has a type' do
          expect(memory_class.find('.type')).to have_text("Photo")
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
      end

      scenario 'lets me go back to the previous page' do
        expect(page).to have_link('Back')
      end

      scenario "let's me edit" do
        expect(page).to have_link('Edit')
      end

      scenario "let's me delete" do
        expect(page).to have_link('Delete')
      end
    end
  end
end

