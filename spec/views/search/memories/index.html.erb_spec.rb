require 'rails_helper'

describe 'search/memories/index.html.erb' do
  let(:user)            { Fabricate(:user) }
  let(:query)           { 'test search'  }
  let(:page)            { '1' }
  let(:scrapbook_count) { 1 }
  let(:results)         { double('results', paged_results: paged_memories, query: query, memory_count: memory_count, scrapbook_count: scrapbook_count) }

  before :each do
    allow(view).to receive(:current_user).and_return(user)
    assign(:results, results)
    render
  end

  context 'when there are no results' do
    let(:memory_count)   { 0 }
    let(:paged_memories) { Kaminari.paginate_array([]).page(page) }

    it 'displays the result count on the memory button' do
      expect(rendered).to have_css('span.button.memories', text: "#{memory_count} memories")
    end

    it 'has a link to the scrapbook results with the number found' do
      expect(rendered).to have_css('a.button.scrapbooks', text: "#{scrapbook_count} scrapbook")
    end

    it "doesn't show an add button" do
      expect(rendered).not_to have_css('.memory.add')
    end

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
                             Fabricate.build(:memory, id: i+1, user: user, title: query)
                           end }
    let(:paged_memories) { Kaminari.paginate_array(memories).page(page) }

    it 'displays the result count' do
      expect(rendered).to have_css('.button.memories', text: "#{memory_count} memories")
    end

    it 'has a link to the scrapbook results with the number found' do
      expect(rendered).to have_css('a.button.scrapbooks', text: "#{scrapbook_count} scrapbook")
    end

    it "doesn't show an add button" do
      expect(rendered).not_to have_css('.memory.add')
    end

    it_behaves_like 'a memory index'
    it_behaves_like 'paginated content'
    it_behaves_like 'add to scrapbook'
  end
end

