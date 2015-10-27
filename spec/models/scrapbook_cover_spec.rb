require 'rails_helper'

describe ScrapbookCover do
  let(:scrapbook)          { double('scrapbook', id: 123, title: 'A test scrapbook')}
  let(:scrapbook_memories) { [] }

  subject { ScrapbookCover.new(scrapbook, scrapbook_memories) }

  describe '#scrapbook' do
    it 'provides the given scrapbook' do
      expect(subject.scrapbook).to eql(scrapbook)
    end
  end

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
      let(:scrapbook_memories) { Array.new(1).map{|sm| Fabricate.build(:scrapbook_photo_memory)} }

      it 'returns 1' do
        expect(subject.memories_count).to eql(1)
      end
    end

    context 'when cover has been initialized with more than one scrapbook_memory' do
      let(:photo_memory)       { Fabricate.build(:scrapbook_photo_memory) }
      let(:text_memory)        { Fabricate.build(:scrapbook_text_memory) }
      let(:scrapbook_memories) { [photo_memory, text_memory] }

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

    context 'when cover has been initialized with one scrapbook_photo_memory' do
      let(:photo_memory)       { Fabricate.build(:scrapbook_photo_memory) }
      let(:scrapbook_memories) { [photo_memory] }

      it "returns the photo memory's memory" do
        expect(subject.main_memory).to eql(photo_memory.memory)
      end
    end

    context 'when cover has been initialized with more than one scrapbook_photo_memory' do
      let(:photo_memory_1)     { Fabricate.build(:scrapbook_photo_memory) }
      let(:photo_memory_2)     { Fabricate.build(:scrapbook_photo_memory) }
      let(:scrapbook_memories) { [photo_memory_1, photo_memory_2] }

      it "returns the first photo memory's memory" do
        expect(subject.main_memory).to eql(photo_memory_1.memory)
      end
    end

    context 'when cover has been initialized with one scrapbook_text_memory' do
      let(:text_memory)        { Fabricate.build(:scrapbook_text_memory) }
      let(:scrapbook_memories) { [text_memory] }

      it "returns the text memory's memory" do
        expect(subject.main_memory).to eql(text_memory.memory)
      end
    end

    context 'when cover has been initialized with more than one scrapbook_text_memory' do
      let(:text_memory_1)     { Fabricate.build(:scrapbook_text_memory) }
      let(:text_memory_2)     { Fabricate.build(:scrapbook_text_memory) }
      let(:scrapbook_memories) { [text_memory_1, text_memory_2] }

      it "returns the first text memory's memory" do
        expect(subject.main_memory).to eql(text_memory_1.memory)
      end
    end

    context 'when cover has been initialized with more than one scrapbook_memory' do
      let(:photo_memory) { Fabricate.build(:scrapbook_photo_memory) }
      let(:text_memory)  { Fabricate.build(:scrapbook_text_memory) }

      context 'when first memory is photo and second is text' do
        let(:scrapbook_memories) { [photo_memory, text_memory] }

        it "returns the photo memory's memory" do
          expect(subject.main_memory).to eql(photo_memory.memory)
        end
      end

      context 'when first memory is text and second is photo' do
        let(:scrapbook_memories) { [text_memory, photo_memory] }

        it "returns the photo memory's memory" do
          expect(subject.main_memory).to eql(photo_memory.memory)
        end
      end
    end
  end

  describe '#secondary_memories' do
    let(:photo_memory_1) { Fabricate.build(:scrapbook_photo_memory) }
    let(:photo_memory_2) { Fabricate.build(:scrapbook_photo_memory) }
    let(:photo_memory_3) { Fabricate.build(:scrapbook_photo_memory) }
    let(:photo_memory_4) { Fabricate.build(:scrapbook_photo_memory) }
    let(:photo_memory_5) { Fabricate.build(:scrapbook_photo_memory) }
    let(:text_memory_1)  { Fabricate.build(:scrapbook_text_memory) }
    let(:text_memory_2)  { Fabricate.build(:scrapbook_text_memory) }
    let(:text_memory_3)  { Fabricate.build(:scrapbook_text_memory) }
    let(:text_memory_4)  { Fabricate.build(:scrapbook_text_memory) }
    let(:text_memory_5)  { Fabricate.build(:scrapbook_text_memory) }

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

    describe 'photo memories' do
      context 'when cover has been initialized with one photo memory' do
        let(:scrapbook_memories) { [photo_memory_1] }

        it 'returns an array of 3 nils' do
          expect(subject.secondary_memories).to eql([nil, nil, nil])
        end
      end

      context 'when cover has been initialized with two photo memories' do
        let(:scrapbook_memories) { [photo_memory_1, photo_memory_2] }

        it "returns an array with the second memory padded with 2 nils" do
          expect(subject.secondary_memories).to eql([photo_memory_2.memory, nil, nil])
        end
      end

      context 'when cover has been initialized with three photo memories' do
        let(:scrapbook_memories) { [photo_memory_1, photo_memory_2, photo_memory_3] }

        it "returns an array with the second and third memories padded with 1 nil" do
          expect(subject.secondary_memories).to eql([photo_memory_2.memory, photo_memory_3.memory, nil])
        end
      end

      context 'when cover has been initialized with four photo memories' do
        let(:scrapbook_memories) { [photo_memory_1, photo_memory_2, photo_memory_3, photo_memory_4] }

        it "returns an array with the second, third and fourth memories with no nil padding" do
          expect(subject.secondary_memories).to eql([photo_memory_2.memory, photo_memory_3.memory, photo_memory_4.memory])
        end
      end

      context 'when cover has been initialized with five photo memories' do
        let(:scrapbook_memories) { [photo_memory_1, photo_memory_2, photo_memory_3, photo_memory_4, photo_memory_5] }

        it "returns an array with the second, third and fourth memories with no nil padding" do
          expect(subject.secondary_memories).to eql([photo_memory_2.memory, photo_memory_3.memory, photo_memory_4.memory])
        end
      end
    end

    describe 'text memories' do
      context 'when cover has been initialized with one text memory' do
        let(:scrapbook_memories) { [text_memory_1] }

        it 'returns an array of 3 nils' do
          expect(subject.secondary_memories).to eql([nil, nil, nil])
        end
      end

      context 'when cover has been initialized with two text memories' do
        let(:scrapbook_memories) { [text_memory_1, text_memory_2] }

        it "returns an array with the second memory padded with 2 nils" do
          expect(subject.secondary_memories).to eql([text_memory_2.memory, nil, nil])
        end
      end

      context 'when cover has been initialized with three text memories' do
        let(:scrapbook_memories) { [text_memory_1, text_memory_2, text_memory_3] }

        it "returns an array with the second and third memories padded with 1 nil" do
          expect(subject.secondary_memories).to eql([text_memory_2.memory, text_memory_3.memory, nil])
        end
      end

      context 'when cover has been initialized with four text memories' do
        let(:scrapbook_memories) { [text_memory_1, text_memory_2, text_memory_3, text_memory_4] }

        it "returns an array with the second, third and fourth memories with no nil padding" do
          expect(subject.secondary_memories).to eql([text_memory_2.memory, text_memory_3.memory, text_memory_4.memory])
        end
      end

      context 'when cover has been initialized with five text memories' do
        let(:scrapbook_memories) { [text_memory_1, text_memory_2, text_memory_3, text_memory_4, text_memory_5] }

        it "returns an array with the second, third and fourth memories with no nil padding" do
          expect(subject.secondary_memories).to eql([text_memory_2.memory, text_memory_3.memory, text_memory_4.memory])
        end
      end
    end

    describe 'memories with mixed types' do
      context 'when first memory is a photo memory' do
        let(:scrapbook_memories) { [photo_memory_1, text_memory_2, photo_memory_3, text_memory_4, photo_memory_5] }

        it 'returns an array with the second, third and fourth memories' do
          expect(subject.secondary_memories).to eql([text_memory_2.memory, photo_memory_3.memory, text_memory_4.memory])
        end
      end

      context 'when the first memory is a text memory' do
        let(:scrapbook_memories) { [text_memory_1, photo_memory_2, text_memory_3, photo_memory_4, text_memory_5] }

        it 'returns an array with the first, third and fourth memories' do
          expect(subject.secondary_memories).to eql([text_memory_1.memory, text_memory_3.memory, photo_memory_4.memory])
        end
      end
    end
  end
end
