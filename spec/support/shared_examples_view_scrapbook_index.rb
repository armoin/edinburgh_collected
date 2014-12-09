RSpec.shared_examples 'a scrapbook index' do
  it "displays all the given scrapbooks" do
    assign(:scrapbooks, scrapbooks)
    render
    expect(rendered).to have_css('#scrapbooks .scrapbook', count: 3)
  end

  describe "a scrapbook" do
    let(:scrapbook)  { scrapbooks.first }
    let(:scope)      { '.scrapbook:nth-child(1)' }

    context "that has no memories" do
      before :each do
        assign(:scrapbooks, scrapbooks)
        allow_any_instance_of(Scrapbook).to receive(:cover_memory).and_return(nil)
        render
      end

      it "does not have a cover image" do
        expect(rendered).to have_css("#{scope} img.ph")
      end

      it "has a title" do
        expect(rendered).to have_css("#{scope} .title", text: scrapbook.title)
      end

      it "states that it is empty" do
        expect(rendered).to have_css("#{scope} h4", text: 'This scrapbook is empty')
      end
    end

    context "that has memories" do
      before :each do
        allow(scrapbook).to receive(:memories).and_return(stub_memories(2))
        assign(:scrapbooks, scrapbooks)
        render
      end

      it "uses a memory image as the cover image" do
        expect(rendered).to have_css("#{scope} img.main")
      end

      it "has a title" do
        expect(rendered).to have_css("#{scope} .title", text: scrapbook.title)
      end

      it "shows how many memories it contains" do
        expect(rendered).to have_css("#{scope} .count", text: '2 memories')
      end
    end
  end
end
