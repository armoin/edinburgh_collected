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

  describe '.cover_memory_for' do
    let(:scrapbook) { Fabricate(:scrapbook) }

    it 'is nil if scrapbook has no memories' do
      expect(ScrapbookMemory.cover_memory_for(scrapbook)).to be_nil
    end

    it 'provides the only memory if scrapbook only has one memory' do
      castle = Fabricate(:scrapbook_memory, scrapbook: scrapbook)
      expect(ScrapbookMemory.cover_memory_for(scrapbook)).to eql(castle.memory)
    end

    it 'provides the memory with the lowest ordering if scrapbook has more than one memory' do
      castle, beach = Fabricate.times(2, :scrapbook_memory, scrapbook: scrapbook)
      castle.update_attribute(:ordering, 2)
      beach.update_attribute(:ordering, 1)
      expect(ScrapbookMemory.cover_memory_for(scrapbook)).to eql(beach.memory)
    end
  end
end
