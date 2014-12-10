require 'rails_helper'

describe 'my/scrapbooks/index.html.erb' do
  let(:user)       { Fabricate.build(:active_user) }
  let(:scrapbooks) { Array.new(3) { Fabricate.build(:scrapbook) } }
  let(:memory)     { Fabricate.build(:photo_memory) }

  before :each do
    allow(view).to receive(:current_user).and_return(user)
    allow_any_instance_of(Scrapbook).to receive(:cover_memory).and_return(memory)
  end

  it "has a link to show all current user's memories" do
    assign(:scrapbooks, scrapbooks)
    render
    expect(rendered).to have_link('Browse your memories', href: my_memories_path)
  end

  it_behaves_like 'a scrapbook index'
end
