require 'rails_helper'

describe 'my/memories/index.html.erb' do
  let(:user)     { Fabricate(:user) }
  let(:memories) { Fabricate.times(3, :photo_memory, user: user) }

  before :each do
    allow(view).to receive(:current_user).and_return(user)
    assign(:memories, memories)
    render
  end

  it 'displays a link to Browse your Scrapbooks' do
    expect(rendered).to have_link('Browse your Scrapbooks', href: my_scrapbooks_path)
  end

  context 'a memory' do
    let(:memory) { memories.first }

    it 'is a link to the show page for that memory' do
      expect(rendered).to have_css("a.memory[href=\"#{my_memory_path(memory)}\"]")
    end
  end

  it_behaves_like 'a memory index'
end


