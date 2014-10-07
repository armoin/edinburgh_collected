require 'rails_helper'

describe 'memories/index.html.erb' do
  let(:user)    { Fabricate(:user) }
  let(:memories)  { Fabricate.times(3, :photo_memory, user: user) }

  before :each do
    assign(:memories, memories)
    render
  end

  it 'displays all existing memories' do
    expect(rendered).to have_css('.memory', count: 3)
  end

  context 'a memory' do
    let(:memory) { memories.first }

    it 'has a title' do
      expect(rendered).to have_css('.memory .title', text: memory.title)
    end

    it 'has a thumbnail image' do
      expect(rendered).to match /img.*alt="#{memory.title}"/
      expect(rendered).to match /img.*src="#{memory.source_url(:thumb)}.*"/
    end

    it 'is a link to the show page for that memory' do
      expect(rendered).to have_css("a.memory[href=\"#{memory_path(memory)}\"]")
    end
  end
end


