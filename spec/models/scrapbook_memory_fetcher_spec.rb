require 'rails_helper'

describe ScrapbookMemoryFetcher do
  describe '#scrapbook_memories_for' do
    let(:owner) { Fabricate.build(:active_user, id: 213) }

    subject { ScrapbookMemoryFetcher.new(scrapbooks, owner.id) }

    context 'when requested scrapbook has memories' do

      let(:approved_memory)         { Fabricate(:approved_memory, user: owner) }
      let(:unapproved_owned_memory) { Fabricate(:pending_memory, user: owner) }
      let(:unapproved_memory)       { Fabricate(:pending_memory) }

      let(:scrapbook_memory_1)    { Fabricate.build(:scrapbook_memory, memory: approved_memory) }
      let(:scrapbook_memory_2)    { Fabricate.build(:scrapbook_memory, memory: approved_memory) }
      let(:scrapbook_memory_3)    { Fabricate.build(:scrapbook_memory, memory: unapproved_owned_memory) }
      let(:scrapbook_memory_4)    { Fabricate.build(:scrapbook_memory, memory: unapproved_memory) }
      let(:scrapbook_memories_1)  { [scrapbook_memory_1, scrapbook_memory_2, scrapbook_memory_3, scrapbook_memory_4]}
      let(:scrapbook_1)           { Fabricate.build(:scrapbook, scrapbook_memories: scrapbook_memories_1, user: owner) }

      let(:scrapbook_memory_5)    { Fabricate.build(:scrapbook_memory, memory: approved_memory) }
      let(:scrapbook_memories_2)  { [scrapbook_memory_5]}
      let(:scrapbook_2)           { Fabricate.build(:scrapbook, scrapbook_memories: scrapbook_memories_2) }

      let(:scrapbooks)            { [scrapbook_1, scrapbook_2] }

      before :each do
        scrapbook_1.save!
        scrapbook_2.save!
      end

      it 'provides approved scrapbook_memories for the given scrapbook' do
        result = subject.scrapbook_memories_for(scrapbook_1)

        expect(result).to include(scrapbook_memory_1)
        expect(result).to include(scrapbook_memory_2)
      end

      it 'also provides unapproved scrapbook_memories for the given scrapbook if they belong to the user' do
        result = subject.scrapbook_memories_for(scrapbook_1)

        expect(result).to include(scrapbook_memory_3)
      end

      it 'does not provide any unapproved scrapbook_memories for the given scrapbook if they do not belong to the user' do
        result = subject.scrapbook_memories_for(scrapbook_1)

        expect(result).not_to include(scrapbook_memory_4)
      end

      it 'does not provide any scrapbook_memories for other scrapbooks' do
        result = subject.scrapbook_memories_for(scrapbook_1)

        expect(result).not_to include(scrapbook_memory_5)
      end

      it 'provides the scrapbook_memories in order' do
        scrapbook_memory_1.update_attribute(:ordering, 4)

        result = subject.scrapbook_memories_for(scrapbook_1)

        expect(result.first).to  eql(scrapbook_memory_2)
        expect(result.second).to eql(scrapbook_memory_3)
        expect(result.last).to   eql(scrapbook_memory_1)
      end
    end

    context 'when requested scrapbook has no memories' do
      let(:scrapbook_memories) { [] }
      let(:scrapbook)          { Fabricate(:scrapbook, scrapbook_memories: scrapbook_memories) }

      let(:scrapbooks)         { [scrapbook] }

      it 'provides an empty array' do
        expect( subject.scrapbook_memories_for(scrapbook) ).to be_empty
      end
    end

    context 'when requested scrapbook is not in given scrapbooks' do
      let(:scrapbook_memories)  { [] }
      let(:present_scrapbook)   { Fabricate(:scrapbook, scrapbook_memories: scrapbook_memories) }
      let(:requested_scrapbook) { Fabricate(:scrapbook) }

      let(:scrapbooks)          { [present_scrapbook] }

      it 'provides an empty array' do
        expect( subject.scrapbook_memories_for(requested_scrapbook) ).to be_empty
      end
    end
  end
end
