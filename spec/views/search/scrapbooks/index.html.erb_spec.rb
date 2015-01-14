require 'rails_helper'

describe 'search/scrapbooks/index.html.erb' do
  let(:user)           { Fabricate(:user) }
  let(:params_stub)    { {query: 'test search'}  }

  context 'when there are no results' do
    let(:scrapbooks)       { [] }
    let(:paged_scrapbooks) { Kaminari.paginate_array(scrapbooks).page(1) }

    before :each do
      allow(view).to receive(:current_user).and_return(user)
      allow(view).to receive(:params).and_return(params_stub)
      assign(:scrapbooks, paged_scrapbooks)
      render
    end

    it 'displays the result count' do
      expect(rendered).to have_css('#contentHeader', text: "Found 0 matches for \"#{params_stub[:query]}\"")
    end

    it "doesn't show an add button" do
      expect(rendered).not_to have_css('.scrapbook.add')
    end

    it "does not display any results" do
      expect(rendered).not_to have_css('.scrapbook')
    end

    it "displays a no results message" do
      expect(rendered).to have_css('.no-results p', text: "Sorry, but we couldn't find any results for \"#{params_stub[:query]}\"")
    end
  end

  context 'when there are results' do
    let(:scrapbooks)       { Fabricate.times(3, :scrapbook, user: user) }
    let(:paged_scrapbooks) { Kaminari.paginate_array(scrapbooks).page(1) }
    let(:memory)           { Fabricate.build(:photo_memory) }

    before :each do
      allow(view).to receive(:current_user).and_return(user)
      allow(view).to receive(:params).and_return(params_stub)
    end

    describe "the results" do
      before :each do
        assign(:scrapbooks, paged_scrapbooks)
        render
      end

      it 'displays the result count' do
        expect(rendered).to have_css('#contentHeader', text: "Found 3 matches for \"#{params_stub[:query]}\"")
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

