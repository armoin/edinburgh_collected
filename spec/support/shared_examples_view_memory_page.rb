RSpec.shared_examples 'a memory page' do
  let(:user)        { Fabricate.build(:active_user, id: 123)}
  let(:owner)       { Fabricate.build(:active_user, id: 456)}
  let(:area)        { Fabricate.build(:area, name: 'Portobello') }
  let(:location)    { 'Kings Road' }
  let(:tags)        { Array.new(2).map.with_index{|m,i| Fabricate.build(:tag, id: i)} }
  let(:attribution) { 'Bobby Tables' }
  let(:memory)      { Fabricate.build(:photo_memory, id: 123, attribution: attribution, area: area, location: location, tags: tags, user: owner) }
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
        it "includes the date" do
          expect(rendered).to have_css('.memory .subtitle', text: '4th May 2014')
        end
      end
    end
  end

  describe "action bar" do
    it 'has a link to the current index' do
      expect(rendered).to have_link('Back', href: '/memories')
    end

    context "when memory belongs to the user" do
      before :each do
        allow(view).to receive(:current_user).and_return(owner)
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
      before :each do
        allow(view).to receive(:current_user).and_return(user)
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
        allow(view).to receive(:current_user).and_return(user)
        render
      end

      it "shows the 'Add to scrapbook' button" do
        expect(rendered).to have_link('Add to scrapbook +')
      end

      it 'has a report button' do
        expect(rendered).to have_link('Report concern')
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
    describe 'user profile' do
      context "when memory belongs to the user" do
        before :each do
          allow(view).to receive(:current_user).and_return(owner)
          render
        end

        it 'shows that the user owns that memory' do
          expect(rendered).to have_css('#user-profile .username', text: 'You')
        end
      end

      context "when memory does not belong to the user" do
        before :each do
          allow(view).to receive(:current_user).and_return(user)
          render
        end

        it 'shows the username of the user who owns the memory' do
          expect(rendered).to have_css('#user-profile .username', text: memory.user.screen_name)
        end
      end

      context "when the user is not logged in" do
        before :each do
          allow(view).to receive(:logged_in?).and_return(false)
          render
        end

        it 'shows the username of the user who owns the memory' do
          expect(rendered).to have_css('#user-profile .username', text: memory.user.screen_name)
        end
      end

      it "is a link to the owner's user page" do
        expect(rendered).to have_link(memory.user.screen_name, href: user_memories_path(user_id: owner.id))
      end
    end

    describe 'metadata' do
      context 'when all details are given' do
        it 'has a description' do
          expect(rendered).to have_css('.memory p', text: "This is a test.", count: 1)
        end

        it 'has an attribution' do
          expect(rendered).to have_css('.memory p#memory-attribution', text: 'Bobby Tables', count: 1)
        end

        it 'has a list of categories' do
          memory.categories.each do |cat|
            expect(rendered).to have_link(cat.name, href: filter_category_path(category: cat.name))
          end
        end

        it 'has a list of tags' do
          memory.tags.each do |tag|
            expect(rendered).to have_link(tag.name, href: filter_tag_path(tag: tag.name))
          end
        end

        it 'has a location that shows the location and area' do
          expect(rendered).to have_css('#memory-location p', text: "Kings Road, Portobello", count: 1)
        end

        it "has a 'See more from this area' button" do
          expect(rendered).to have_link("See more memories from #{area.name}", href: filter_area_path(area: area.name))
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

      context 'when there is no location' do
        let(:location) { nil }

        context 'and there is no area' do
          let(:area) { nil }

          it "does not show the location" do
            expect(rendered).not_to have_css('#memory-location p')
          end
        end

        context 'but there is an area' do
          it "shows the area only in the location" do
            expect(rendered).to have_css('#memory-location p', text: "Portobello", count: 1)
          end
        end
      end

      context 'when there is no area' do
        let(:area) { nil }

        it "only shows the location in the Location" do
          expect(rendered).to have_css('#memory-location p', text: "Kings Road", count: 1)
        end

        it "does not have a 'See more from this area' button" do
          expect(rendered).not_to have_link("See more memories from Portobello")
        end
      end
    end
  end
end