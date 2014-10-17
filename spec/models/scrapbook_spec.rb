require 'rails_helper'

describe Scrapbook do
  describe 'validation' do
    it 'must have a title' do
      expect(subject).to be_invalid
      expect(subject.errors[:title]).to include("can't be blank")
    end

    it 'must belong to a user' do
      expect(subject).to be_invalid
      expect(subject.errors[:user]).to include("can't be blank")
    end
  end

  describe '#cover_memory' do
    it 'is nil if scrapbook has no memories' do
      allow(ScrapbookMemory).to receive(:cover_memory_for).with(subject).and_return(nil)
      expect(subject.cover_memory).to be_nil
    end

    it 'provides the supplied memory if scrapbook has memories' do
      memory = Fabricate.build(:photo_memory)
      allow(ScrapbookMemory).to receive(:cover_memory_for).with(subject).and_return(memory)
      expect(subject.cover_memory).to eql(memory)
    end
  end
end
