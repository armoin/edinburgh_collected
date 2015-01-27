require 'rails_helper'

describe 'search/memories/index.html.erb' do
  let(:query)           { 'test search'  }
  let(:paged_memories)  { [] }
  let(:memory_count)    { 0 }
  let(:scrapbook_count) { 0 }
  let(:results)         { double('results', query: query, memory_count: memory_count, scrapbook_count: scrapbook_count) }

  before :each do
    assign(:results, results)
    assign(:memories, paged_memories)
    render
  end

  describe 'action bar' do
    before :each do
      render
    end

    it 'it does not show the "Add a memory" button' do
      expect(rendered).not_to have_link('Add a memory')
    end

    describe 'memory result count' do
      let(:link_text) { 'span.button.memories' }

      context 'when there are no memories' do
        let(:memory_count) { 0 }

        it 'displays the count as 0' do
          expect(rendered).to have_css(link_text, text: "0 memories")
        end
      end

      context 'when there is one memory' do
        let(:memory_count) { 1 }

        it 'displays the count as 1' do
          expect(rendered).to have_css(link_text, text: "1 memory")
        end
      end

      context 'when there is more than one memory' do
        let(:memory_count) { 2 }

        it 'displays the count as 2' do
          expect(rendered).to have_css(link_text, text: "2 memories")
        end
      end
    end

    describe 'link to scrapbook results' do
      let(:link_text) { 'a.button.scrapbooks' }

      context 'when there are no scrapbooks' do
        let(:scrapbook_count) { 0 }

        it 'has a link with the number of results shown' do
          expect(rendered).to have_css(link_text, text: "0 scrapbooks")
        end
      end

      context 'when there is 1 scrapbook' do
        let(:scrapbook_count) { 1 }

        it 'has a link with the number of results shown' do
          expect(rendered).to have_css(link_text, text: "1 scrapbook")
        end
      end

      context 'when there is more than one scrapbook' do
        let(:scrapbook_count) { 2 }

        it 'has a link with the number of results shown' do
          expect(rendered).to have_css(link_text, text: "2 scrapbooks")
        end
      end
    end
  end

  context 'when there are no results' do
    let(:paged_memories) { Kaminari.paginate_array([]).page(1) }

    it "does not display any results" do
      expect(rendered).not_to have_css('.memory')
    end

    it "displays a no results message" do
      expect(rendered).to have_css('.no-results p', text: "Sorry, but we couldn't find any results for \"#{query}\"")
    end
  end

  context 'when there are results' do
    let(:memory_count)   { 3 }
    let(:memories)       { Array.new(memory_count).map.with_index do |m, i|
                             Fabricate.build(:memory, id: i+1)
                           end }
    let(:paged_memories) { Kaminari.paginate_array(memories).page(1) }

    it_behaves_like 'a memory index'
    it_behaves_like 'paginated content'
    it_behaves_like 'add to scrapbook'
  end
end

