RSpec.shared_examples 'a scrapbook page' do
  let(:owner)                { Fabricate.build(:user, id: 456) }
  let(:user)                 { nil }
  let(:scrapbook)            { Fabricate.build(:scrapbook, id: 123, user: owner) }
  let(:can_modify)           { false }
  let(:memories)             { [] }
  let(:paginated_memories)   { Kaminari.paginate_array(memories).page(nil) }

  before :each do
    allow(view).to receive(:current_user).and_return(user)
    assign(:scrapbook, scrapbook)
    assign(:memories, paginated_memories)
  end

  describe "memories" do
    context 'when there are no memories' do
      let(:memories) { [] }

      context 'when the user is logged in' do
        let(:user) { Fabricate.build(:active_user) }

        before :each do
          allow(user).to receive(:can_modify?).and_return(can_modify)
          render
        end

        context "when scrapbook doesn't belong to the user" do
          let(:can_modify) { false }

          it 'does not display the Add Memories instructions' do
            expect(rendered).not_to have_css('.scrapbook__instructions')
          end
        end

        context "when scrapbook belongs to the user" do
          let(:can_modify) { true }

          it 'displays the Add Memories instructions' do
            expect(rendered).to have_css('.scrapbook__instructions')
          end
        end
      end
    end

    context 'when there are memories' do
      let(:memories) { stub_memories(3) }

      before :each do
        render
      end

      it "displays a thumbnail for each memory" do
        expect(rendered).to have_css('.memory', count: 3)
      end

      it "displays the memory's image" do
        expect(rendered).to match /1\.jpg/
        expect(rendered).to match /2\.jpg/
        expect(rendered).to match /3\.jpg/
      end

      it "displays the memory's title" do
        expect(rendered).to match /Test 1/
        expect(rendered).to match /Test 2/
        expect(rendered).to match /Test 3/
      end
    end
  end

  describe "scrapbook details" do
    it "displays the title" do
      render
      expect(rendered).to have_content(scrapbook.title)
    end

    it "displays the description" do
      render
      expect(rendered).to have_content(scrapbook.description)
    end

    describe "owner details" do
      let(:user_page_link) { user_scrapbooks_path(user_id: owner.id) }
      let(:label)          { 'Created by' }

      before :each do
        render
      end

      it_behaves_like 'an owner details page'
    end
  end

  it_behaves_like 'a shareable page'

  it_behaves_like 'a reportable page'
end
