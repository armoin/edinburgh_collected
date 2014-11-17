require 'rails_helper'

describe 'scrapbooks/index.html.erb' do
  let(:scrapbooks) { Array.new(3) { Fabricate.build(:scrapbook) } }
  let(:memory)     { Fabricate.build(:photo_memory) }

  before :each do
    allow_any_instance_of(Scrapbook).to receive(:cover_memory).and_return(memory)
  end

  it 'has a link to show all memories' do
    assign(:scrapbooks, scrapbooks)
    render
    expect(rendered).to have_link('Browse Memories', href: memories_path)
  end

  it_behaves_like 'a scrapbook index'
end
