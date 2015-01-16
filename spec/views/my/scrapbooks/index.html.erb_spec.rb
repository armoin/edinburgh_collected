require 'rails_helper'

describe 'my/scrapbooks/index.html.erb' do
  let(:user)             { Fabricate.build(:active_user) }
  let(:logged_in)        { false }
  let(:scrapbooks)       { Array.new(3) { Fabricate.build(:scrapbook) } }
  let(:paged_scrapbooks) { Kaminari.paginate_array(scrapbooks).page(1) }
  let(:memory)           { Fabricate.build(:photo_memory) }

  before :each do
    allow(view).to receive(:current_user).and_return(user)
    allow(view).to receive(:logged_in?).and_return(logged_in)
  end

  describe 'action bar' do
    before :each do
      assign(:scrapbooks, paged_scrapbooks)
      render
    end

    it "has a link to show all current user's memories" do
      expect(rendered).to have_link('Memories', href: my_memories_path)
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
