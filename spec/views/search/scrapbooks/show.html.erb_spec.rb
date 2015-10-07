require 'rails_helper'

describe "search/scrapbooks/show.html.erb" do
  describe "action bar" do
    let(:user)               { Fabricate.build(:user, id: 123) }
    let(:scrapbook)          { Fabricate.build(:scrapbook, id: 456, user: user) }
    let(:memories)           { [] }
    let(:paginated_memories) { Kaminari.paginate_array(memories).page(nil) }
    let(:query)              { 'test string' }

    let(:current_user)       { nil }
    let(:can_modify)         { false }

    before :each do
      allow(view).to receive(:params).and_return(query: query)

      assign(:scrapbook, scrapbook)
      assign(:memories, paginated_memories)

      allow(view).to receive(:current_user).and_return(current_user)
      allow(user).to receive(:can_modify?).and_return(can_modify)

      render
    end

    it "has a button to the search results page" do
      expect(rendered).to have_link('Search results', href: search_scrapbooks_path(query: query))
    end

    context "when the user is not logged in" do
      let(:current_user) { nil }

      it "does not have an edit link" do
        expect(rendered).not_to have_link('Edit')
      end

      it "does not have a delete link" do
        expect(rendered).not_to have_link('Delete')
      end

      it "does not have an 'Add more memories' link" do
        expect(rendered).not_to have_link('Add more memories')
      end
    end

    context "when the user is logged in" do
      let(:current_user) { user }

      context "when scrapbook doesn't belong to the user" do
        let(:can_modify) { false }

        it "does not have an edit link" do
          expect(rendered).not_to have_link('Edit')
        end

        it "does not have a delete link" do
          expect(rendered).not_to have_link('Delete')
        end

        it "does not have an 'Add more memories' link" do
          expect(rendered).not_to have_link('Add more memories')
        end
      end

      context "when scrapbook belongs to the user" do
        let(:can_modify) { true }

        it "does not have an edit link" do
          expect(rendered).not_to have_link('Edit')
        end

        it "does not have a delete link" do
          expect(rendered).not_to have_link('Delete')
        end

        it "does not have an 'Add more memories' link" do
          expect(rendered).not_to have_link('Add more memories')
        end
      end
    end
  end

  it_behaves_like 'a scrapbook page'
end
