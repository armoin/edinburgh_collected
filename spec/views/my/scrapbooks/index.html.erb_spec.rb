require 'rails_helper'

describe 'my/scrapbooks/index.html.erb' do
  let(:user)                    { Fabricate.build(:active_user) }
  let(:logged_in)               { false }

  let(:memory_count)            { 1 }
  let(:memories)                { Array.new(memory_count) { Fabricate.build(:memory) } }
  
  let(:scrapbook_count)         { 3 }
  let(:scrapbooks)              { Array.new(scrapbook_count) { Fabricate.build(:scrapbook) } }
  let(:paged_scrapbooks)        { Kaminari.paginate_array(scrapbooks) }
  
  let(:scrapbook_memory_count)  { 0 }
  let(:scrapbook_memories)      { Array.new(scrapbook_memory_count).map{|sm| Fabricate.build(:scrapbook_memory)} }
  let(:stub_memory_fetcher)     { double('memory_catcher') }
  let(:presenter)               { ScrapbookIndexPresenter.new(paged_scrapbooks, stub_memory_fetcher) }


  before :each do
    allow(view).to receive(:current_user).and_return(user)
    allow(view).to receive(:logged_in?).and_return(logged_in)
    
    allow(user).to receive(:memories).and_return(memories)
    allow(user).to receive(:scrapbooks).and_return(scrapbooks)

    allow(stub_memory_fetcher).to receive(:scrapbook_memories_for).and_return(scrapbook_memories)
    assign(:presenter, presenter)

    render
  end

  describe 'action bar' do
    it 'displays the result count on the scrapbook button' do
      expect(rendered).to have_css('span.button.scrapbooks', text: "#{scrapbook_count} scrapbooks")
    end

    it 'has a link to the memory results with the number found' do
      expect(rendered).to have_css('a.button.memories', text: "#{memory_count} memory")
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
end
