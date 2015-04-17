require 'rails_helper'

describe 'scrapbooks/index.html.erb' do
  let(:logged_in)               { false }
  let(:current_user)            { nil }

  let(:scrapbook_count)         { 3 }
  let(:scrapbooks)              { Array.new(scrapbook_count) { Fabricate.build(:scrapbook) } }
  let(:paged_scrapbooks)        { Kaminari.paginate_array(scrapbooks) }

  let(:scrapbook_memory_count)  { 0 }
  let(:scrapbook_memories)      { Array.new(scrapbook_memory_count).map{|sm| Fabricate.build(:scrapbook_memory)} }
  let(:stub_memory_fetcher)     { double('memory_catcher') }
  let(:presenter)               { ScrapbookIndexPresenter.new(paged_scrapbooks, stub_memory_fetcher) }

  before :each do
    allow(view).to receive(:logged_in?).and_return(logged_in)
    allow(view).to receive(:current_user).and_return(current_user)

    allow(stub_memory_fetcher).to receive(:scrapbook_memories_for).and_return(scrapbook_memories)
    assign(:presenter, presenter)

    render
  end

  describe 'action bar' do
    it "has a link to show all current user's memories" do
      expect(rendered).to have_link('Memories', href: memories_path)
    end

    context 'when the user is not logged in' do
      let(:logged_in) { false }

      it 'it does not show the "Create a scrapbook" button' do
        expect(rendered).not_to have_link('Create a scrapbook')
      end
    end

    context 'when the user is logged in' do
      let(:logged_in) { true }

      it 'it shows the "Create a scrapbook" button' do
        expect(rendered).to have_link('Create a scrapbook')
      end
    end
  end

  it_behaves_like 'paginated content'
  it_behaves_like 'a scrapbook index'

  let(:moderatable) { scrapbooks.first }
  it_behaves_like 'non state labelled content'
end
