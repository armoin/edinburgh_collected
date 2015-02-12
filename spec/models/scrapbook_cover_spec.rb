require 'rails_helper'

describe ScrapbookCover do
  let(:scrapbook)          { double('scrapbook', id: 123, title: 'A test scrapbook')}
  let(:scrapbook_memories) { [] }

  subject { ScrapbookCover.new(scrapbook, scrapbook_memories) }

  describe '#scrapbook_id' do
    it 'provides the id for the given scrapbook' do
      expect(subject.scrapbook_id).to eql(scrapbook.id)
    end
  end

  describe '#title' do
    it 'provides the title for the given scrapbook' do
      expect(subject.title).to eql(scrapbook.title)
    end
  end

  describe '#memories_count' do
    context 'when cover has been initialized with nil scrapbook_memories' do
      let(:scrapbook_memories) { nil }

      it 'returns 0' do
        expect(subject.memories_count).to eql(0)
      end
    end

    context 'when cover has been initialized with empty scrapbook_memories' do
      let(:scrapbook_memories) { nil }

      it 'returns 0' do
        expect(subject.memories_count).to eql(0)
      end
    end

    context 'when cover has been initialized with one scrapbook_memory' do
      let(:scrapbook_memories) { Array.new(1).map{|sm| Fabricate.build(:scrapbook_memory)} }

      it 'returns 1' do
        expect(subject.memories_count).to eql(1)
      end
    end

    context 'when cover has been initialized with more than one scrapbook_memory' do
      let(:scrapbook_memories) { Array.new(2).map{|sm| Fabricate.build(:scrapbook_memory)} }

      it 'returns the number of scrapbook_memories' do
        expect(subject.memories_count).to eql(2)
      end
    end
  end

  describe '#main_memory' do
    context 'when cover has been initialized with nil scrapbook_memories' do
      let(:scrapbook_memories) { nil }

      it 'returns nil' do
        expect(subject.main_memory).to be_nil
      end
    end
    
    context 'when cover has been initialized with empty scrapbook_memories' do
      let(:scrapbook_memories) { [] }

      it 'returns nil' do
        expect(subject.main_memory).to be_nil
      end
    end

    context 'when cover has been initialized with one scrapbook_memory' do
      let(:scrapbook_memories) { Array.new(1).map{|sm| Fabricate.build(:scrapbook_memory)} }

      it "returns the first scrapbook_memory's memory" do
        expect(subject.main_memory).to eql(scrapbook_memories.first.memory)
      end
    end

    context 'when cover has been initialized with more than one scrapbook_memory' do
      let(:scrapbook_memories) { Array.new(2).map{|sm| Fabricate.build(:scrapbook_memory)} }

      it "returns the first scrapbook_memory's memory" do
        expect(subject.main_memory).to eql(scrapbook_memories.first.memory)
      end
    end
  end

  describe '#secondary_memories' do
    let(:memories) { scrapbook_memories.map(&:memory) }

    context 'when cover has been initialized with nil scrapbook_memories' do
      let(:scrapbook_memories) { nil }

      it 'returns an array of 3 nils' do
        expect(subject.secondary_memories).to eql([nil, nil, nil])
      end
    end
    
    context 'when cover has been initialized with empty scrapbook_memories' do
      let(:scrapbook_memories) { [] }

      it 'returns an array of 3 nils' do
        expect(subject.secondary_memories).to eql([nil, nil, nil])
      end
    end

    context 'when cover has been initialized with one scrapbook_memory' do
      let(:scrapbook_memories) { Array.new(1).map{|sm| Fabricate.build(:scrapbook_memory)} }

      it 'returns an array of 3 nils' do
        expect(subject.secondary_memories).to eql([nil, nil, nil])
      end
    end

    context 'when cover has been initialized with two scrapbook_memories' do
      let(:scrapbook_memories) { Array.new(2).map{|sm| Fabricate.build(:scrapbook_memory)} }

      it "returns an array with the second memory padded with 2 nils" do
        expect(subject.secondary_memories).to eql([memories[1], nil, nil])
      end
    end

    context 'when cover has been initialized with three scrapbook_memories' do
      let(:scrapbook_memories) { Array.new(3).map{|sm| Fabricate.build(:scrapbook_memory)} }

      it "returns an array with the second and third memories padded with 1 nil" do
        expect(subject.secondary_memories).to eql([memories[1], memories[2], nil])
      end
    end

    context 'when cover has been initialized with four scrapbook_memories' do
      let(:scrapbook_memories) { Array.new(4).map{|sm| Fabricate.build(:scrapbook_memory)} }

      it "returns an array with the second, third and fourth memories with no nil padding" do
        expect(subject.secondary_memories).to eql([memories[1], memories[2], memories[3]])
      end
    end

    context 'when cover has been initialized with five scrapbook_memories' do
      let(:scrapbook_memories) { Array.new(5).map{|sm| Fabricate.build(:scrapbook_memory)} }

      it "returns an array with the second, third and fourth memories with no nil padding" do
        expect(subject.secondary_memories).to eql([memories[1], memories[2], memories[3]])
      end
    end
  end
end
