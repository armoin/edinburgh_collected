require 'rails_helper'

describe 'search/scrapbooks/index.html.erb' do
  let(:user)            { Fabricate(:user) }
  let(:query)           { 'test search'  }
  let(:page)            { '1' }
  let(:memory_count)    { 1 }
  let(:results)         { double('results', paged_results: paged_scrapbooks, query: query, memory_count: memory_count, scrapbook_count: scrapbook_count) }

  before :each do
    allow(view).to receive(:current_user).and_return(user)
    assign(:results, results)
  end

  context 'when there are no results' do
    let(:scrapbook_count)  { 0 }
    let(:paged_scrapbooks) { Kaminari.paginate_array([]).page(page) }

    before :each do
      render
    end

    it 'displays the result count on the scrapbook button' do
      expect(rendered).to have_css('span.button.scrapbooks', text: "#{scrapbook_count} scrapbooks")
    end

    it 'has a link to the memory results with the number found' do
      expect(rendered).to have_css('a.button.memories', text: "#{memory_count} memory")
    end

    it "doesn't show an add button" do
      expect(rendered).not_to have_css('.scrapbook.add')
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
                               Fabricate.build(:scrapbook, user: user, title: query)
                             end }
    let(:paged_scrapbooks) { Kaminari.paginate_array(scrapbooks).page(page) }
    let(:memory)           { Fabricate.build(:photo_memory) }

    describe 'results' do
      before :each do
        render
      end

      it 'displays the result count on the scrapbook button' do
        expect(rendered).to have_css('span.button.scrapbooks', text: "#{scrapbook_count} scrapbooks")
      end

      it 'has a link to the memory results with the number found' do
        expect(rendered).to have_css('a.button.memories', text: "#{memory_count} memory")
      end

      it "doesn't show an add button" do
        expect(rendered).not_to have_css('.scrapbook.add')
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

