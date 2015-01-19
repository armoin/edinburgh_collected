require 'rails_helper'

describe 'my/memories/index.html.erb' do
  let(:user)            { Fabricate(:user) }
  let(:memory_count)    { 3 }
  let(:scrapbook_count) { 1 }
  let(:memories)        { Fabricate.times(memory_count, :photo_memory, user: user) }
  let(:scrapbooks)      { Array.new(scrapbook_count).map.with_index{|x,i| Fabricate.build(:scrapbook, id: i)} }
  let(:paged_memories)  { Kaminari.paginate_array(memories).page(1) }

  before :each do
    allow(view).to receive(:current_user).and_return(user)
    allow(user).to receive(:memories).and_return(memories)
    allow(user).to receive(:scrapbooks).and_return(scrapbooks)
    assign(:memories, paged_memories)
    render
  end

  it 'displays the result count on the memory button' do
    expect(rendered).to have_css('span.button.memories', text: "#{memory_count} memories")
  end

  it 'has a link to the scrapbook results with the number found' do
    expect(rendered).to have_css('a.button.scrapbooks', text: "#{scrapbook_count} scrapbook")
  end

  it "shows an add button" do
    expect(rendered).to have_link('Add a memory', href: new_my_memory_path)
  end

  context 'a memory' do
    let(:memory) { memories.first }

    it_behaves_like 'state labelled content'
  end

  it_behaves_like 'a memory index'
  it_behaves_like 'paginated content'
end

