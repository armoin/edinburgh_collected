require 'rails_helper'

describe 'search/scrapbooks/index.html.erb' do
  let(:query)                   { 'test search' }

  let(:memory_count)            { 0 }
  let(:scrapbook_count)         { 0 }
  
  let(:results)                 { double('results', query: query, memory_count: memory_count, scrapbook_count: scrapbook_count) }
  
  let(:scrapbooks)              { Array.new(scrapbook_count) { Fabricate.build(:scrapbook) } }
  let(:paged_scrapbooks)        { Kaminari.paginate_array(scrapbooks) }

  let(:scrapbook_memory_count)  { 0 }
  let(:scrapbook_memories)      { Array.new(scrapbook_memory_count).map{|sm| Fabricate.build(:scrapbook_memory)} }
  let(:stub_memory_fetcher)     { double('memory_catcher') }
  let(:presenter)               { ScrapbookIndexPresenter.new(paged_scrapbooks, stub_memory_fetcher) }

  before :each do
    assign(:results, results)
    
    allow(stub_memory_fetcher).to receive(:scrapbook_memories_for).and_return(scrapbook_memories)
    assign(:presenter, presenter)

    render
  end

  describe 'action bar' do
    it 'it does not show the "Create a scrapbook" button' do
      expect(rendered).not_to have_link('Create a scrapbook')
    end

    describe 'link to memory results' do
      let(:link_text) { 'a.button.memories' }

      context 'when there are no memories' do
        let(:memory_count) { 0 }

        it 'has a link with the number of results shown' do
          expect(rendered).to have_css(link_text, text: "0 memories")
        end
      end

      context 'when there is 1 memory' do
        let(:memory_count) { 1 }

        it 'has a link with the number of results shown' do
          expect(rendered).to have_css(link_text, text: "1 memory")
        end
      end

      context 'when there is more than one memory' do
        let(:memory_count) { 2 }

        it 'has a link with the number of results shown' do
          expect(rendered).to have_css(link_text, text: "2 memories")
        end
      end
    end

    describe 'scrapbook result count' do
      let(:link_text) { 'span.button.scrapbooks' }

      context 'when there are no scrapbooks' do
        let(:scrapbook_count) { 0 }

        it 'displays the count as 0' do
          expect(rendered).to have_css(link_text, text: "0 scrapbooks")
        end
      end

      context 'when there is one scrapbook' do
        let(:scrapbook_count) { 1 }

        it 'displays the count as 1' do
          expect(rendered).to have_css(link_text, text: "1 scrapbook")
        end
      end

      context 'when there is more than one scrapbook' do
        let(:scrapbook_count) { 2 }

        it 'displays the count as 2' do
          expect(rendered).to have_css(link_text, text: "2 scrapbooks")
        end
      end
    end
  end

  context 'when there are no results' do
    let(:scrapbook_count) { 0 }

    it "does not display any results" do
      expect(rendered).not_to have_css('.scrapbook')
    end

    it "displays a no results message" do
      expect(rendered).to have_css('.no-results p', text: "Sorry, but we couldn't find any approved scrapbooks for \"#{query}\"")
    end
  end

  context 'when there are results' do
    let(:scrapbook_count)  { 3 }
    
    it_behaves_like 'paginated content'

    it_behaves_like 'a scrapbook index'
  end
end

