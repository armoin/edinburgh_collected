require 'rails_helper'

describe 'users/scrapbooks/index.html.erb' do
  let(:current_user)            { Fabricate.build(:active_user, id: 123) }
  let(:requested_user)          { Fabricate.build(:active_user, id: 456) }
  let(:logged_in)               { false }

  let(:memory_count)            { 1 }
  let(:memories)                { double }
  let(:visible_memories)        { Array.new(memory_count) { Fabricate.build(:memory) } }

  let(:scrapbook_count)         { 3 }
  let(:scrapbooks)              { Array.new(scrapbook_count) { |i| Fabricate.build(:scrapbook, id: i+1, user: requested_user) } }
  let(:paged_scrapbooks)        { Kaminari.paginate_array(scrapbooks) }

  let(:scrapbook_memory_count)  { 0 }
  let(:scrapbook_memories)      { Array.new(scrapbook_memory_count).map{|sm| Fabricate.build(:scrapbook_memory)} }
  let(:stub_memory_fetcher)     { double('memory_catcher') }
  let(:presenter)               { ScrapbookIndexPresenter.new(paged_scrapbooks, stub_memory_fetcher) }


  before :each do
    allow(view).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:logged_in?).and_return(logged_in)

    allow(stub_memory_fetcher).to receive(:scrapbook_memories_for).and_return(scrapbook_memories)
    assign(:presenter, presenter)

    assign(:requested_user, requested_user)
  end

  # TODO: Need to add tests around the profile header

  describe 'action bar' do
    before :each do
      allow(requested_user).to receive(:memories).and_return(memories)
      allow(memories).to receive(:publicly_visible).and_return(visible_memories)
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

      it 'it does not show the "Create a scrapbook" button' do
        expect(rendered).not_to have_link('Create a scrapbook')
      end
    end
  end

  describe 'content' do
    before :each do
      render
    end

    it_behaves_like 'paginated content'
    it_behaves_like 'a scrapbook index'
  end

  describe 'an individual scrapbook' do
    let(:scrapbook) { scrapbooks.first }

    it 'links to the user scrapbooks show page' do
      render
      expect(rendered).to have_css("a.scrapbook.thumb[href=\"/users/456/scrapbooks/#{scrapbook.id}\"]")
    end

    # TODO: need to change this to be "does not behave like state-labelled content"
    # let(:moderatable) { scrapbook }
    # it_behaves_like 'state labelled content'
  end
end
