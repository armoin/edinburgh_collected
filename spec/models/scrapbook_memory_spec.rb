require 'rails_helper'

describe ScrapbookMemory do
  describe 'order' do
    it 'default ordering is by id' do
      mem2 = Fabricate(:scrapbook_memory, id:2)
      mem1 = Fabricate(:scrapbook_memory, id:1)
      expect(ScrapbookMemory.first).to eql(mem1)
      expect(ScrapbookMemory.last).to eql(mem2)
    end

    it 'can be ordered by the ordering value' do
      scrapbook = Fabricate.build(:scrapbook, id: 123)
      mem2 = Fabricate(:scrapbook_memory, scrapbook: scrapbook)
      mem1 = Fabricate(:scrapbook_memory, scrapbook: scrapbook)
      expect(ScrapbookMemory.by_ordering.first).to eql(mem2)
      expect(ScrapbookMemory.by_ordering.last).to eql(mem1)
    end
  end

  describe 'saving' do
    describe 'assigning an ordering' do
      context 'on create' do
        let(:scrapbook) { Fabricate.build(:scrapbook, id: 123) }
        let(:memories) { [] }

        before :each do
          allow(scrapbook).to receive(:memories).and_return(memories)
        end

        context "if there are no other memories in the scrapbook" do
          let(:memories) { [] }

          it 'assigns 0' do
            subject.scrapbook = scrapbook
            subject.save!
            expect(subject.ordering).to eql(0)
          end
        end

        context 'if there is one other memory in the scrapbook' do
          let(:memories) { ["a memory"] }

          it 'assigns 1' do
            subject.scrapbook= scrapbook
            subject.save!
            expect(subject.ordering).to eql(1)
          end
        end

        context 'if there are six other memories in the scrapbook' do
          let(:memories) { Array.new(6) {|n| "memory #{n}"} }

          it 'assigns 6' do
            subject.scrapbook= scrapbook
            subject.save!
            expect(subject.ordering).to eql(6)
          end
        end
      end
    end
  end

  describe '.reorder_for_scrapbook' do
    let(:scrapbook)       { Fabricate(:scrapbook) }
    let(:other_scrapbook) { Fabricate(:scrapbook) }

    before :each do
      Fabricate(:scrapbook_memory, scrapbook: scrapbook, id: 1)
      Fabricate(:scrapbook_memory, scrapbook: scrapbook, id: 2)
    end

    it 'reorders according to the given ordering' do
      ScrapbookMemory.reorder_for_scrapbook(scrapbook, [2,1])
      resulting_ids = ScrapbookMemory.where(scrapbook_id: scrapbook).by_ordering.map(&:id)
      expect(resulting_ids).to eql([2,1])
    end

    it 'does nothing if no ordering is given' do
      ScrapbookMemory.reorder_for_scrapbook(scrapbook, [])
      resulting_ids = ScrapbookMemory.where(scrapbook_id: scrapbook).by_ordering.map(&:id)
      expect(resulting_ids).to eql([1,2])
    end

    it 'raises a NoMethodError if no scrapbook is given' do
      expect {
        ScrapbookMemory.reorder_for_scrapbook(nil, [1,2])
      }.to raise_error(NoMethodError)
    end

    it "raises a NoMethodError if scrapbook memory ids don't belong to given scrapbook" do
      expect {
        ScrapbookMemory.reorder_for_scrapbook(other_scrapbook, [1,2])
      }.to raise_error(NoMethodError)
    end

    it "does not commit any orderings if there is an error" do
      expect {
        ScrapbookMemory.reorder_for_scrapbook(scrapbook, [2,1,3])
      }.to raise_error(NoMethodError)
      resulting_ids = ScrapbookMemory.where(scrapbook_id: scrapbook).by_ordering.map(&:id)
      expect(resulting_ids).to eql([1,2])
    end
  end

  describe '.remove_from_scrapbook' do
    let(:scrapbook)       { Fabricate(:scrapbook) }
    let(:other_scrapbook) { Fabricate(:scrapbook) }

    before :each do
      Fabricate(:scrapbook_memory, scrapbook: scrapbook, id: 1)
      Fabricate(:scrapbook_memory, scrapbook: scrapbook, id: 2)
    end

    it 'does nothing if no ids to delete are given' do
      expect {
        ScrapbookMemory.remove_from_scrapbook(scrapbook, [])
      }.not_to change{ScrapbookMemory.count}
    end

    it 'removes the scrapbook_memory with the given id if one id is given' do
      expect {
        ScrapbookMemory.remove_from_scrapbook(scrapbook, [1])
      }.to change{ScrapbookMemory.count}.by(-1)
    end

    it 'removes all scrapbook_memories if all ids are given' do
      expect {
        ScrapbookMemory.remove_from_scrapbook(scrapbook, [1,2])
      }.to change{ScrapbookMemory.count}.by(-2)
    end

    it 'raises a NoMethodError if no scrapbook is given' do
      expect {
        ScrapbookMemory.remove_from_scrapbook(nil, [1,2])
      }.to raise_error(NoMethodError)
    end

    it "raises a NoMethodError if scrapbook memory ids don't belong to given scrapbook" do
      expect {
        ScrapbookMemory.remove_from_scrapbook(other_scrapbook, [1,2])
      }.to raise_error(NoMethodError)
    end

    it "does not delete any if there is an error" do
      expect {
        ScrapbookMemory.remove_from_scrapbook(scrapbook, [1,2,3])
      }.to raise_error(NoMethodError)
      expect(ScrapbookMemory.count).to eql(2)
    end
  end
end
