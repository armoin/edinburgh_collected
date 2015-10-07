require 'rails_helper'

describe "scrapbooks/show.html.erb" do
  let(:scrapbook)          { Fabricate.build(:scrapbook, id: 456, user: Fabricate.build(:user, id: 123)) }
  let(:memories)           { [] }
  let(:paginated_memories) { Kaminari.paginate_array(memories).page(nil) }

  before :each do
    assign(:scrapbook, scrapbook)
    assign(:memories, paginated_memories)
  end

  describe "action bar" do
    it "has a button to the scrapbook index page" do
      render
      expect(rendered).to have_link('All scrapbooks', href: scrapbooks_path)
    end

    context "when the user is not logged in" do
      let(:user) { nil }

      before :each do
        render
      end

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
      let(:user) { Fabricate.build(:active_user, id: 123) }

      before :each do
        allow(view).to receive(:current_user).and_return(user)
        allow(user).to receive(:can_modify?).and_return(can_modify)
        render
      end

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
