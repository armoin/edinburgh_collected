require 'rails_helper'

describe ScrapbookCoverPresenter do
  let(:scrapbook) { Fabricate.build(:scrapbook, id: 123) }
  let(:memories)  { Array.new(3).map{|m| Fabricate.build(:memory) } }

  subject { ScrapbookCoverPresenter.new(scrapbook) }

  before :each do
    allow(scrapbook).to receive(:approved_ordered_memories).and_return(memories)
    allow(CoverMemoriesPresenter).to receive(:new)
  end

  describe '#path_to_scrapbook' do
    it 'returns the root show path for that scrapbook' do
      expect(subject.path_to_scrapbook).to eql('/scrapbooks/123')
    end
  end

  describe '#scrapbook' do
    it 'returns the given scrapbook' do
      expect(subject.scrapbook).to eql(scrapbook)
    end
  end

  describe '#cover' do
    it "builds a CoverMemoriesPresenter for the scrapbook's approved memories" do
      subject.cover
      expect(CoverMemoriesPresenter).to have_received(:new).with(memories)
    end
  end
end
