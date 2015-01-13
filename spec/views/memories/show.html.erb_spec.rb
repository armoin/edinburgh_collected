require 'rails_helper'

describe "memories/show.html.erb" do
  let(:memory) { Fabricate.build(:photo_memory, id: 123) }
  let(:edit_path)   { edit_my_memory_path(memory.id) }
  let(:delete_path) { my_memory_path(memory.id) }

  it 'has a link to the current index' do
    assign(:memory, memory)
    render
    expect(rendered).to have_link('Back', href: '/memories')
  end

  it "displays a memory" do
    assign(:memory, memory)
    render
    expect(rendered).to have_css('.memory')
  end

  describe 'the memory' do
    context 'when all details are given' do
      before :each do
        assign(:memory, memory)
        render
      end

      it 'has a title' do
        expect(rendered).to have_css('.memory .title', text: memory.title)
      end

      it "has the full date" do
        expect(rendered).to have_css('.memory .sub', text: '4th May 2014')
      end

      it 'has an image' do
        expect(rendered).to match /img.*alt="#{memory.title}"/
        expect(rendered).to match /img.*src="#{memory.source_url}.*"/
      end

      it 'has a description' do
        expect(rendered).to have_css('.memory p', text: "This is a test.", count: 1)
      end

      it 'has an attribution' do
        expect(rendered).to have_css('.memory p#memory-attribution', text: '', count: 1)
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

      it "has an area" do
        expect(rendered).to have_css('.memory #memory-area h3', text: "#{CITY} area", count: 1)
        expect(rendered).to have_css('.memory #memory-area a', text: 'Portobello', count: 1)
      end

      it "has a location" do
        expect(rendered).to have_css('.memory #memory-location h3', text: 'Location', count: 1)
        expect(rendered).to have_css('.memory #memory-location p', text: 'Kings Road', count: 1)
      end
    end

    context 'when there are no tags' do
      before :each do
        memory.tags = []
        memory.save!
        assign(:memory, memory)
        render
      end

      it "shows the tags header" do
        expect(rendered).to have_css('.memory #memory-tags h3', text: 'Tags', count: 1)
      end

      it "does not have any tags" do
        expect(rendered).not_to have_css('.memory #memory-tags li a')
      end
    end

    context 'when there is no area' do
      before :each do
        memory.area = nil
        memory.save!
        assign(:memory, memory)
        render
      end

      it "shows the area header" do
        expect(rendered).to have_css('.memory #memory-area h3', text: "#{CITY} area", count: 1)
      end

      it "does not have an area" do
        expect(rendered).not_to have_css('.memory #memory-area a')
      end
    end

    context 'when there is no location' do
      before :each do
        memory.location = nil
        memory.save!
        assign(:memory, memory)
        render
      end

      it "shows the location header" do
        expect(rendered).not_to have_css('.memory #memory-location h3')
      end

      it "does not have a location" do
        expect(rendered).not_to have_css('.memory #memory-location ul li')
      end
    end
  end

  context "when memory belongs to the user" do
    let(:user) { Fabricate.build(:active_user) }

    before :each do
      assign(:memory, memory)
      allow(view).to receive(:current_user).and_return(user)
      allow(user).to receive(:can_modify?).and_return(true)
      render
    end

    it "has an edit link" do
      expect(rendered).to have_link('Edit this memory', href: edit_path)
    end

    it "has a delete link" do
      expect(rendered).to have_link('Delete this memory', href: delete_path)
    end
  end

  context "when memory does not belong to the user" do
    let(:user) { Fabricate.build(:active_user) }

    before :each do
      assign(:memory, memory)
      allow(view).to receive(:current_user).and_return(user)
      allow(user).to receive(:can_modify?).and_return(false)
      render
    end

    it "does not have an edit link" do
      expect(rendered).not_to have_link('Edit this memory', href: edit_path)
    end

    it "does not have a delete link" do
      expect(rendered).not_to have_link('Delete this memory', href: delete_path)
    end
  end
end
