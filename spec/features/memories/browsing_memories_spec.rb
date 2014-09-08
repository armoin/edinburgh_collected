require 'rails_helper'

feature 'As a user I want to be able to manage my memories', slow: true do
  let(:user)    { Fabricate(:user) }
  let(:area)    { Fabricate(:area) }
  let(:memories)  { Fabricate.times(3, :photo_memory, user: user, area: area) }

  before :each do
    allow(Memory).to receive(:all).and_return(memories)
  end

  feature 'So that I can view my existing memories' do
    context 'an memory' do
      let(:memory) { find('.memory:first') }

      before :each do
        visit '/memories'
      end

      scenario 'fetches the requested memories' do
        expect(Memory).to have_received(:all)
      end

      it 'has a title' do
        expect(memory.find('.title')).to have_text("A test")
      end

      it 'has an image' do
        img = memory.find('img')
        expect(img['src']).to have_content("test.jpg")
        expect(img['alt']).to have_content("A test")
      end
    end

    scenario 'displays all existing memories' do
      visit '/memories'
      expect(page).to have_css('.memory', count: 3)
    end
  end

  feature 'So that I can view details on a selected memory' do
    scenario 'clicking on the View details link' do
      visit '/memories'
      find('.memory[data-id="1"]').click
      expect(current_path).to eql('/memories/1')
    end
  end
end

