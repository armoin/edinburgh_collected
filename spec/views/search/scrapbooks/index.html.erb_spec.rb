require 'rails_helper'

describe 'search/scrapbooks/index.html.erb' do
  let(:query)            { 'test search'  }
  let(:memory_count)     { 0 }
  let(:scrapbook_count)  { 0 }
  let(:results)          { double('results', query: query, memory_count: memory_count, scrapbook_count: scrapbook_count) }
  let(:paged_scrapbooks) { Kaminari.paginate_array([]).page(1) }

  before :each do
    assign(:results, results)
    assign(:scrapbooks, paged_scrapbooks)
  end

  describe 'action bar' do
    before :each do
      render
    end

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
    let(:paged_scrapbooks) { Kaminari.paginate_array([]).page(1) }

    before :each do
      render
    end

    it "does not display any results" do
      expect(rendered).not_to have_css('.scrapbook')
    end

    it "displays a no results message" do
      expect(rendered).to have_css('.no-results p', text: "Sorry, but we couldn't find any results for \"#{query}\"")
    end
  end

  context 'when there are results' do
    let(:scrapbook_count)  { 3 }
    let(:scrapbooks)       { Array.new(scrapbook_count).map.with_index do |s, i|
                               Fabricate.build(:scrapbook, id: i+1)
                             end }
    let(:paged_scrapbooks) { Kaminari.paginate_array(scrapbooks).page(1) }

    describe 'results' do
      before :each do
        render
      end

      context 'a scrapbook' do
        let(:scrapbook) { scrapbooks.first }

        it 'is a link to the show page for that scrapbook' do
          expect(rendered).to have_css("a.scrapbook[href=\"#{scrapbook_path(scrapbook)}\"]")
        end
      end

      it_behaves_like 'paginated content'
    end

    it_behaves_like 'a scrapbook index'
  end
end

