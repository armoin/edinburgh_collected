require('rails_helper')

describe ScrapbookIndexPresenter do
  let(:scrapbook_memory_fetcher) { double('scrapbook_memory_fetcher') }

  describe '#scrapbook_covers' do
    let(:scrapbook_memories_1) { Array.new(1).map{|sm| Fabricate.build(:scrapbook_memory)} }
    let(:scrapbook_1)          { Fabricate.build(:scrapbook, id: 123) }

    let(:scrapbook_memories_2) { Array.new(2).map{|sm| Fabricate.build(:scrapbook_memory)} }
    let(:scrapbook_2)          { Fabricate.build(:scrapbook, id: 456) }

    subject { ScrapbookIndexPresenter.new([scrapbook_1, scrapbook_2], scrapbook_memory_fetcher) }

    before :each do
      allow(scrapbook_memory_fetcher).to receive(:scrapbook_memories_for).with(scrapbook_1).and_return(scrapbook_memories_1)
      allow(scrapbook_memory_fetcher).to receive(:scrapbook_memories_for).with(scrapbook_2).and_return(scrapbook_memories_2)

      allow(ScrapbookCover).to receive(:new)
    end

    it 'provides a scrapbook cover for all given scrapbooks' do
      subject.scrapbook_covers
      expect(ScrapbookCover).to have_received(:new).with(scrapbook_1, scrapbook_memories_1)
      expect(ScrapbookCover).to have_received(:new).with(scrapbook_2, scrapbook_memories_2)
    end
  end

  describe '#scrapbooks_count' do
    subject { ScrapbookIndexPresenter.new(scrapbooks, scrapbook_memory_fetcher) }
        
    context 'when nil scrapbooks are given' do
      let(:scrapbooks) { nil }

      it 'returns 0 if no scrapbooks are given' do
        expect(subject.scrapbooks_count).to eql(0)
      end
    end

    context 'when no scrapbooks are given' do
      let(:scrapbooks) { [] }

      it 'returns 0 if no scrapbooks are given' do
        expect(subject.scrapbooks_count).to eql(0)
      end
    end

    context 'when no scrapbooks are given' do
      let(:scrapbooks) { ['scrapbook'] }

      it 'returns 1 if one scrapbook is given' do
        expect(subject.scrapbooks_count).to eql(1)
      end
    end

    context 'when no scrapbooks are given' do
      let(:scrapbooks) { ['scrapbook', 'scrapbook'] }

      it 'returns 2 if two scrapbooks are given' do
        expect(subject.scrapbooks_count).to eql(2)
      end
    end
  end

  describe '#paginated_scrapbooks' do
    let(:scrapbooks) { Scrapbook.none }

    before :each do
      allow(scrapbooks).to receive(:page)
    end

    context "when no page number is given" do
      it "asks for paginated scrapbooks without specifying the page" do
        ScrapbookIndexPresenter.new(scrapbooks, scrapbook_memory_fetcher).paginated_scrapbooks
        expect(scrapbooks).to have_received(:page).with(nil)
      end
    end

    context "when a page number is given" do
      it "asks for paginated scrapbooks specifying the given page" do
        ScrapbookIndexPresenter.new(scrapbooks, scrapbook_memory_fetcher, 2).paginated_scrapbooks
        expect(scrapbooks).to have_received(:page).with(2)
      end
    end
  end

  describe '#paginated_scrapbook_covers' do
    let(:scrapbook_memories_1) { Array.new(1).map{|sm| Fabricate.build(:scrapbook_memory)} }
    let(:scrapbook_1)          { Fabricate.build(:scrapbook, id: 123) }

    let(:scrapbook_memories_2) { Array.new(2).map{|sm| Fabricate.build(:scrapbook_memory)} }
    let(:scrapbook_2)          { Fabricate.build(:scrapbook, id: 456) }

    let(:scrapbooks)           { Kaminari.paginate_array( [scrapbook_1, scrapbook_2] ) }
    let(:scrapbooks_page_2)    { [scrapbook_2] }

    subject { ScrapbookIndexPresenter.new(scrapbooks, scrapbook_memory_fetcher, 2) }

    before :each do
      allow(scrapbooks).to receive(:page).with(2).and_return(scrapbooks_page_2)

      allow(scrapbook_memory_fetcher).to receive(:scrapbook_memories_for).with(scrapbook_1).and_return(scrapbook_memories_1)
      allow(scrapbook_memory_fetcher).to receive(:scrapbook_memories_for).with(scrapbook_2).and_return(scrapbook_memories_2)

      allow(ScrapbookCover).to receive(:new)
    end

    it 'provides a scrapbook cover for the given page of scrapbooks' do
      subject.paginated_scrapbook_covers
      expect(ScrapbookCover).not_to have_received(:new).with(scrapbook_1, scrapbook_memories_1)
      expect(ScrapbookCover).to have_received(:new).with(scrapbook_2, scrapbook_memories_2)
    end
  end
end
