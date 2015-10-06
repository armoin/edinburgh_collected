require 'rails_helper'

describe "search/memories/show.html.erb" do
  describe "action bar" do
    let(:user)         { Fabricate.build(:active_user, id: 123)}
    let(:memory)       { Fabricate.build(:photo_memory, id: 456, user: user) }
    let(:query)        { 'This is a query string' }
    let(:current_user) { nil }
    let(:logged_in)    { false }
    let(:can_modify)   { false }

    before :each do
      assign(:memory, memory)
      assign(:query, query)
      allow(view).to receive(:logged_in?).and_return(logged_in)
      allow(view).to receive(:current_user).and_return(current_user)
      allow(user).to receive(:can_modify?).and_return(can_modify)
      render
    end

    context 'when logged in' do
      let(:logged_in)    { true }
      let(:current_user) { user }

      it "has a button to the search memories page including the given query string" do
        expect(rendered).to have_link('Search results', href: search_memories_path(query: 'This is a query string'))
      end

      it "shows the 'Add to scrapbook' button" do
        expect(rendered).to have_link('Scrapbook')
      end

      context 'and cannot modify the memory' do
        let(:can_modify) { false }

        it "does not have an edit link" do
          expect(rendered).not_to have_link('Edit')
        end

        it "does not have a delete link" do
          expect(rendered).not_to have_link('Delete')
        end

        it 'has a report button' do
          expect(rendered).to have_link('Report a concern')
        end
      end

      context 'and can modify the memory' do
        let(:can_modify) { true }

        it "does not have an edit link" do
          expect(rendered).not_to have_link('Edit')
        end

        it "does not have a delete link" do
          expect(rendered).not_to have_link('Delete')
        end

        it 'does not have a report button' do
          expect(rendered).not_to have_link('Report a concern')
        end
      end
    end

    context 'when not logged in' do
      it "has a button to the search memories page including the given query string" do
        expect(rendered).to have_link('Search results', href: search_memories_path(query: 'This is a query string'))
      end

      it "does not have an edit link" do
        expect(rendered).not_to have_link('Edit')
      end

      it "does not have a delete link" do
        expect(rendered).not_to have_link('Delete')
      end

      it "does not show the 'Add to scrapbook' button" do
        expect(rendered).not_to have_link('Scrapbook')
      end

      it 'does not have a report button' do
        expect(rendered).not_to have_link('Report a concern')
      end
    end
  end

  it_behaves_like 'a memory page'
end
