require 'rails_helper'

describe 'scrapbooks/index.html.erb' do
  let(:logged_in)        { false }
  let(:scrapbook_count)  { 3 }
  let(:scrapbooks)       { Array.new(scrapbook_count).map.with_index do |s, i|
                             ScrapbookCoverPresenter.new(Fabricate.build(:scrapbook, id: i+1))
                           end }
  let(:paged_scrapbooks) { Kaminari.paginate_array(scrapbooks).page(1) }
  let(:memory)           { Fabricate.build(:photo_memory) }

  before :each do
    allow(view).to receive(:logged_in?).and_return(logged_in)
  end

  describe 'action bar' do
    before :each do
      assign(:scrapbooks, paged_scrapbooks)
      render
    end

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

  it_behaves_like 'a scrapbook index'
end
