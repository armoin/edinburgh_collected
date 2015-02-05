require 'rails_helper'

describe "memories/show.html.erb" do
  let(:area)        { Fabricate.build(:area, name: 'Portobello') }
  let(:location)    { 'Kings Road' }
  let(:tags)        { Array.new(2).map.with_index{|m,i| Fabricate.build(:tag, id: i)} }
  let(:attribution) { 'Bobby Tables' }
  let(:memory)      { Fabricate.build(:photo_memory, id: 123, attribution: attribution, area: area, location: location, tags: tags) }
  let(:edit_path)   { edit_my_memory_path(memory.id) }
  let(:delete_path) { my_memory_path(memory.id) }

  before :each do
    assign(:memory, memory)
    render
  end

  it "displays a memory" do
    expect(rendered).to have_css('.memory')
  end

  describe "page header" do
    context 'when all details are given' do
      it 'has a title' do
        expect(rendered).to have_css('.memory .title', text: memory.title)
      end

      context 'has a subtitle that' do
        it "includes the location" do
          expect(rendered).to have_css('.memory .subtitle', text: 'Kings Road', count: 1)
        end

        it "includes the area" do
          expect(rendered).to have_css('.memory .subtitle', text: 'Portobello', count: 1)
        end

        it "includes the date" do
          expect(rendered).to have_css('.memory .subtitle', text: '4th May 2014')
        end
      end
    end

    context 'when there is no area' do
      let(:area) { nil }

      it "does not show the area in the header" do
        expect(rendered).not_to have_css('.memory .subtitle', text: 'Portobello')
      end
    end

    context 'when there is no location' do
      let(:location) { nil }

      it "does not show the area in the header" do
        expect(rendered).not_to have_css('.memory .subtitle', text: 'Kings Road')
      end
    end
  end

  describe "action bar" do
    it 'has a link to the current index' do
      expect(rendered).to have_link('Back', href: '/memories')
    end

    context "when memory belongs to the user" do
      let(:user) { Fabricate.build(:active_user) }

      before :each do
        allow(view).to receive(:current_user).and_return(user)
        allow(user).to receive(:can_modify?).and_return(true)
        render
      end

      it "has an edit link" do
        expect(rendered).to have_link('Edit', href: edit_path)
      end

      it "has a delete link" do
        expect(rendered).to have_link('Delete', href: delete_path)
      end
    end

    context "when memory does not belong to the user" do
      let(:user) { Fabricate.build(:active_user) }

      before :each do
        allow(view).to receive(:current_user).and_return(user)
        allow(user).to receive(:can_modify?).and_return(false)
        render
      end

      it "does not have an edit link" do
        expect(rendered).not_to have_link('Edit', href: edit_path)
      end

      it "does not have a delete link" do
        expect(rendered).not_to have_link('Delete', href: delete_path)
      end
    end

    context "when the user is logged in" do
      before :each do
        allow(view).to receive(:logged_in?).and_return(true)
        render
      end

      it "shows the 'Add to scrapbook' button" do
        expect(rendered).to have_link('Add to scrapbook +')
      end
    end

    context "when the user is not logged in" do
      before :each do
        allow(view).to receive(:logged_in?).and_return(false)
        render
      end

      it "does not show the 'Add to scrapbook' button" do
        expect(rendered).not_to have_link('Add to scrapbook +')
      end
    end
  end

  describe "image" do
    it 'has the correct title' do
      expect(rendered).to match /img.*alt="#{memory.title}"/
    end

    it 'has the correct source' do
      expect(rendered).to match /img.*src="#{memory.source_url}.*"/
    end
  end

  describe "details" do
    context 'when all details are given' do
      it 'has a description' do
        expect(rendered).to have_css('.memory p', text: "This is a test.", count: 1)
      end

      it 'has an attribution' do
        expect(rendered).to have_css('.memory p#memory-attribution', text: 'Bobby Tables', count: 1)
      end

      it 'has a list of categories' do
        memory.categories.each do |cat|
          expect(rendered).to have_css('.memory #memory-categories ul li', text: cat.name)
        end
      end

      it 'has a list of tags' do
        memory.tags.each do |tag|
          expect(rendered).to have_css('.memory #memory-tags ul li', text: tag.name)
        end
      end

      it "has a 'See more from this area' button" do
        expect(rendered).to have_css('.memory #memory-area a', text: 'See more memories from Portobello', count: 1)
      end
    end

    context 'when there is no attribution' do
      let(:attribution) { nil }

      it 'does not have an attribution' do
        expect(rendered).not_to have_css('.memory p#memory-attribution')
      end
    end

    context 'when there are no tags' do
      let(:tags) { [] }

      it "shows the tags header" do
        expect(rendered).to have_css('.memory #memory-tags h3', text: 'Tags', count: 1)
      end

      it "does not have any tags" do
        expect(rendered).not_to have_css('.memory #memory-tags li a')
      end
    end

    context 'when there is no area' do
      let(:area) { nil }

      it "does not have a 'See more from this area' button" do
        expect(rendered).not_to have_css('.memory #memory-area a', text: 'See more memories from Portobello')
      end
    end
  end
end
