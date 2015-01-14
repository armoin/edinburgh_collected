require 'rails_helper'

describe 'scrapbooks/index.html.erb' do
  let(:scrapbooks)       { Array.new(3) { Fabricate.build(:scrapbook) } }
  let(:paged_scrapbooks) { Kaminari.paginate_array(scrapbooks).page(1) }
  let(:memory)           { Fabricate.build(:photo_memory) }

  it 'has a link to show all memories' do
    assign(:scrapbooks, paged_scrapbooks)
    render
    expect(rendered).to have_link('Memories', href: memories_path)
  end

  it_behaves_like 'a scrapbook index'
end
