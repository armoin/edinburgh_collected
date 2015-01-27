require 'rails_helper'

describe 'my/scrapbooks/index.html.erb' do
  let(:user)             { Fabricate.build(:active_user) }
  let(:logged_in)        { false }
  let(:memory_count)     { 1 }
  let(:scrapbook_count)  { 3 }
  let(:scrapbooks)       { Array.new(scrapbook_count) { Fabricate.build(:scrapbook) } }
  let(:memories)         { Array.new(memory_count) { Fabricate.build(:memory) } }
  let(:presenters)       { scrapbooks.map{|s| OwnedScrapbookCoverPresenter.new(s)} }
  let(:paged_scrapbooks) { Kaminari.paginate_array(presenters).page(1) }
  let(:memory)           { Fabricate.build(:photo_memory) }

  before :each do
    allow(view).to receive(:current_user).and_return(user)
    allow(user).to receive(:memories).and_return(memories)
    allow(user).to receive(:scrapbooks).and_return(scrapbooks)
    allow(view).to receive(:logged_in?).and_return(logged_in)
  end

  describe 'action bar' do
    before :each do
      assign(:scrapbooks, paged_scrapbooks)
      render
    end

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

  it_behaves_like 'a scrapbook index'
end
