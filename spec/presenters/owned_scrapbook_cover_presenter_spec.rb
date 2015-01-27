require 'rails_helper'

describe OwnedScrapbookCoverPresenter do
  let(:scrapbook) { Fabricate.build(:scrapbook, id: 123) }
  let(:memories)  { Array.new(3).map{|m| Fabricate.build(:memory) } }

  subject { OwnedScrapbookCoverPresenter.new(scrapbook) }

  before :each do
    allow(scrapbook).to receive(:ordered_memories).and_return(memories)
    allow(CoverMemoriesPresenter).to receive(:new)
  end

  describe '#path_to_scrapbook' do
    it 'returns the my show path for that scrapbook' do
      expect(subject.path_to_scrapbook).to eql('/my/scrapbooks/123')
    end
  end

  describe '#scrapbook' do
    it 'returns the given scrapbook' do
      expect(subject.scrapbook).to eql(scrapbook)
    end
  end

  describe '#cover' do
    it "builds a CoverMemoriesPresenter for all the scrapbook's memories" do
      subject.cover
      expect(CoverMemoriesPresenter).to have_received(:new).with(memories)
    end
  end
end
