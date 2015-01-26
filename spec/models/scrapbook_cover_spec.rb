require 'rails_helper'

describe ScrapbookCover do
  describe '#main_memory' do
    subject { ScrapbookCover.new(scrapbook) }

    context 'when cover has been initialized with a nil scrapbook' do
      let(:scrapbook) { nil }

      it 'returns nil' do
        expect(subject.main_memory).to be_nil
      end
    end

    context 'when cover has been initialized with something that is not scrapbook' do
      let(:scrapbook) { ScrapbookCover.new(double('not_scrapbook')) }

      it 'returns nil' do
        expect(subject.main_memory).to be_nil
      end
    end

    context 'when a scrapbook has been given' do
      let(:scrapbook) { Fabricate.build(:scrapbook) }

      context 'when scrapbook has no memories attached' do
        it 'returns nil' do
          expect(subject.main_memory).to be_nil
        end
      end

      context 'when scrapbook has one memory attached' do
        it "returns that memory" do
          memory = Fabricate.build(:photo_memory)
          scrapbook.memories << memory
          scrapbook.save!
          expect(subject.main_memory).to eql(memory)
        end
      end

      context 'when scrapbook has more than one memory attached' do
        it "returns the first memory" do
          first_memory = Fabricate.build(:photo_memory)
          second_memory = Fabricate.build(:photo_memory)
          scrapbook.memories << first_memory
          scrapbook.memories << second_memory
          scrapbook.save!
          expect(subject.main_memory).to eql(first_memory)
        end
      end
    end
  end

  describe '#secondary_memories' do
    subject { ScrapbookCover.new(scrapbook) }

    context 'when cover has been initialized with a nil scrapbook' do
      let(:scrapbook) { nil }

      it 'returns array of nils' do
        expect(subject.secondary_memories).to eql([nil, nil, nil])
      end
    end

    context 'when cover has been initialized with something that is not scrapbook' do
      let(:scrapbook) { ScrapbookCover.new(double('not_scrapbook')) }

      it 'returns array of nils' do
        expect(subject.secondary_memories).to eql([nil, nil, nil])
      end
    end

    context 'when a scrapbook has been given' do
      let(:scrapbook) { Fabricate.build(:scrapbook) }

      context 'when scrapbook has no memories attached' do
        it 'returns array of nils' do
          expect(subject.secondary_memories).to eql([nil, nil, nil])
        end
      end

      context 'when scrapbook has one memory attached' do
        it 'returns array of nils' do
          memory = Fabricate.build(:photo_memory)
          scrapbook.memories << memory
          scrapbook.save!
          expect(subject.secondary_memories).to eql([nil, nil, nil])
        end
      end

      context 'when scrapbook has two memories attached' do
        it "returns array with second memory first, padded with nils" do
          first_memory = Fabricate.build(:photo_memory)
          second_memory = Fabricate.build(:photo_memory)
          scrapbook.memories << first_memory
          scrapbook.memories << second_memory
          scrapbook.save!
          expect(subject.secondary_memories).to eql([second_memory, nil, nil])
        end
      end

      context 'when scrapbook has three memories attached' do
        it "returns array with second memory then third memory, padded with nils" do
          first_memory = Fabricate.build(:photo_memory)
          second_memory = Fabricate.build(:photo_memory)
          third_memory = Fabricate.build(:photo_memory)
          scrapbook.memories << first_memory
          scrapbook.memories << second_memory
          scrapbook.memories << third_memory
          scrapbook.save!
          expect(subject.secondary_memories).to eql([second_memory, third_memory, nil])
        end
      end

      context 'when scrapbook has four memories attached' do
        it "returns array with second memory then third memory then fourth memory" do
          first_memory = Fabricate.build(:photo_memory)
          second_memory = Fabricate.build(:photo_memory)
          third_memory = Fabricate.build(:photo_memory)
          fourth_memory = Fabricate.build(:photo_memory)
          scrapbook.memories << first_memory
          scrapbook.memories << second_memory
          scrapbook.memories << third_memory
          scrapbook.memories << fourth_memory
          scrapbook.save!
          expect(subject.secondary_memories).to eql([second_memory, third_memory, fourth_memory])
        end
      end

      context 'when scrapbook has five memories attached' do
        it "returns array with second memory then third memory then fourth memory" do
          first_memory = Fabricate.build(:photo_memory)
          second_memory = Fabricate.build(:photo_memory)
          third_memory = Fabricate.build(:photo_memory)
          fourth_memory = Fabricate.build(:photo_memory)
          five_memory = Fabricate.build(:photo_memory)
          scrapbook.memories << first_memory
          scrapbook.memories << second_memory
          scrapbook.memories << third_memory
          scrapbook.memories << fourth_memory
          scrapbook.memories << five_memory
          scrapbook.save!
          expect(subject.secondary_memories).to eql([second_memory, third_memory, fourth_memory])
        end
      end
    end
  end

  describe '#memory_count' do
    subject { ScrapbookCover.new(scrapbook) }

    context 'when cover has been initialized with a nil scrapbook' do
      let(:scrapbook) { nil }

      it 'returns 0' do
        expect(subject.memory_count).to eql(0)
      end
    end

    context 'when cover has been initialized with something that is not scrapbook' do
      let(:scrapbook) { ScrapbookCover.new(double('not_scrapbook')) }

      it 'returns 0' do
        expect(subject.memory_count).to eql(0)
      end
    end

    context 'when a scrapbook has been given' do
      let(:scrapbook) { Fabricate.build(:scrapbook) }

      context 'when scrapbook has no memories attached' do
        it 'returns 0' do
          expect(subject.memory_count).to eql(0)
        end
      end

      context 'when scrapbook has one memory attached' do
        it "returns 1" do
          memory = Fabricate.build(:photo_memory)
          scrapbook.memories << memory
          scrapbook.save!
          expect(subject.memory_count).to eql(1)
        end
      end

      context 'when scrapbook has two memories attached' do
        it "returns 2" do
          first_memory = Fabricate.build(:photo_memory)
          second_memory = Fabricate.build(:photo_memory)
          scrapbook.memories << first_memory
          scrapbook.memories << second_memory
          scrapbook.save!
          expect(subject.memory_count).to eql(2)
        end
      end
    end
  end
end
