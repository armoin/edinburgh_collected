RSpec.shared_examples 'a scrapbook index' do
  let(:presenter)    { paged_scrapbooks.first }
  let(:num_memories) { 0 }
  let(:stub_cover)   { CoverMemoriesPresenter.new(stub_memories(num_memories)) }

  before :each do
    allow(presenter).to receive(:cover).and_return(stub_cover)
    assign(:scrapbooks, paged_scrapbooks)
    render
  end

  it "displays all the given scrapbooks" do
    expect(rendered).to have_css('#scrapbooks .scrapbook', count: 3)
  end

  describe "a scrapbook cover" do
    let(:scope)     { '.scrapbook:nth-child(1)' }

    context "that has no memories" do
      let(:num_memories) { 0 }

      it "does not have a cover image" do
        expect(rendered).to have_css("#{scope} img.ph")
      end

      it "has a title" do
        expect(rendered).to have_css("#{scope} .scrapbookTitle", text: presenter.scrapbook.title)
      end

      it "states that it is empty" do
        expect(rendered).to have_css("#{scope} h4", text: 'This scrapbook is empty')
      end
    end

    context "that has memories" do
      let(:num_memories) { 2 }

      it "uses a memory image as the cover image" do
        expect(rendered).to have_css("#{scope} img.main")
      end

      it "has a title" do
        expect(rendered).to have_css("#{scope} .scrapbookTitle", text: presenter.scrapbook.title)
      end

      it "shows how many memories it contains" do
        expect(rendered).to have_css("#{scope} .count span", text: num_memories)
      end
    end
  end
end
