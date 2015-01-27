require 'spec_helper'
require_relative '../../app/presenters/cover_memories_presenter'

describe CoverMemoriesPresenter do
  describe '#main_memory' do
    it 'is nil if there are no memories' do
      subject = CoverMemoriesPresenter.new([])
      expect(subject.main_memory).to be_nil
    end

    it 'provides the first memory if there is one memory' do
      subject = CoverMemoriesPresenter.new(['memory_1'])
      expect(subject.main_memory).to eql('memory_1')
    end

    it 'provides the first memory if there is more than one memory' do
      subject = CoverMemoriesPresenter.new(['memory_1', 'memory_2', 'memory_3'])
      expect(subject.main_memory).to eql('memory_1')
    end
  end

  describe '#secondary_memories' do
    it 'returns an array of nils if there are no memories' do
      subject = CoverMemoriesPresenter.new([])
      expect(subject.secondary_memories).to eql([nil, nil, nil])
    end

    it 'returns an array of nils if there is one memory' do
      subject = CoverMemoriesPresenter.new(['memory_1'])
      expect(subject.secondary_memories).to eql([nil, nil, nil])
    end

    it 'returns an array with 1 memory padded with nils if there are two memories' do
      subject = CoverMemoriesPresenter.new(['memory_1', 'memory_2'])
      expect(subject.secondary_memories).to eql(['memory_2', nil, nil])
    end

    it 'returns an array with 2 memories padded with nils if there are three memories' do
      subject = CoverMemoriesPresenter.new(['memory_1', 'memory_2', 'memory_3'])
      expect(subject.secondary_memories).to eql(['memory_2', 'memory_3', nil])
    end

    it 'returns an array with 3 memories if there are four memories' do
      subject = CoverMemoriesPresenter.new(['memory_1', 'memory_2', 'memory_3', 'memory_4'])
      expect(subject.secondary_memories).to eql(['memory_2', 'memory_3', 'memory_4'])
    end

    it 'returns an array with 3 memories if there are five memories' do
      subject = CoverMemoriesPresenter.new(['memory_1', 'memory_2', 'memory_3', 'memory_4', 'memory_5'])
      expect(subject.secondary_memories).to eql(['memory_2', 'memory_3', 'memory_4'])
    end
  end

  describe '#memory_count' do
    it 'returns 0 if there are no memories' do
      subject = CoverMemoriesPresenter.new([])
      expect(subject.memory_count).to eql(0)
    end

    it 'returns 1 if there is one memory' do
      subject = CoverMemoriesPresenter.new(['memory_1'])
      expect(subject.memory_count).to eql(1)
    end

    it 'returns 3 if there are three memories' do
      subject = CoverMemoriesPresenter.new(['memory_1', 'memory_2', 'memory_3'])
      expect(subject.memory_count).to eql(3)
    end
  end
end
