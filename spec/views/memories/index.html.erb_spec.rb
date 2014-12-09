require 'rails_helper'

describe 'memories/index.html.erb' do
  let(:user)           { Fabricate(:user) }
  let(:memories)       { Fabricate.times(3, :photo_memory, user: user) }
  let(:paged_memories) { Kaminari.paginate_array(memories).page(1) }

  before :each do
    allow(view).to receive(:current_user).and_return(user)
    assign(:memories, paged_memories)
    render
  end

  it 'displays a link to Browse all Scrapbooks' do
    expect(rendered).to have_link('Browse scrapbooks', href: scrapbooks_path)
  end

  context 'a memory' do
    let(:memory) { memories.first }

    it 'is a link to the show page for that memory' do
      expect(rendered).to have_css("a.memory[href=\"#{memory_path(memory)}\"]")
    end
  end

  it_behaves_like 'a memory index'
  it_behaves_like 'paginated content'
end

