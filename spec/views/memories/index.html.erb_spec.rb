require 'rails_helper'

describe 'memories/index.html.erb' do
  let(:current_user)   { nil }
  let(:memories)       { Array.new(3) {|i| Fabricate.build(:memory, id: i+1) } }
  let(:paged_memories) { Kaminari.paginate_array(memories).page(1) }

  before :each do
    allow(view).to receive(:current_user).and_return(current_user)
    assign(:memories, paged_memories)
    render
  end

  it 'displays a link to Browse all Scrapbooks' do
    expect(rendered).to have_link('Scrapbooks', href: scrapbooks_path)
  end

  it "shows an add button" do
    expect(rendered).to have_link('Add a memory', href: add_memory_my_memories_path)
  end

  it_behaves_like 'a memory index'
  it_behaves_like 'paginated content'
  it_behaves_like 'add to scrapbook'

  let(:moderatable) { memories.first }
  it_behaves_like 'non state labelled content'
end

