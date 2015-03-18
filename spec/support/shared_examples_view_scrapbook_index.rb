RSpec.shared_examples 'a scrapbook index' do
  it "displays all the given scrapbooks" do
    expect(rendered).to have_css('#scrapbooks .scrapbook', count: scrapbook_count)
  end

  describe "a scrapbook cover" do
    let(:scope)           { '.scrapbook:nth-child(1)' }
    let(:scrapbook_cover) { presenter.scrapbook_covers.first }

    context "that has no memories" do
      let(:scrapbook_memory_count)  { 0 }

      it "does not have a cover image" do
        expect(rendered).to have_css("#{scope} img.ph")
      end

      it "has a title" do
        expect(rendered).to have_css("#{scope} .scrapbookTitle", text: scrapbook_cover.title)
      end

      it "states that it is empty" do
        expect(rendered).to have_css("#{scope} h4", text: 'This scrapbook is empty')
      end
    end

    context "that has memories" do
      let(:scrapbook_memory_count)  { 3 }

      it "uses a memory image as the cover image" do
        expect(rendered).to have_css("#{scope} img.main")
      end

      it "has a title" do
        expect(rendered).to have_css("#{scope} .scrapbookTitle", text: scrapbook_cover.title)
      end

      it "shows how many memories it contains" do
        expect(rendered).to have_css("#{scope} .count span", text: 3)
      end
    end
  end
end
