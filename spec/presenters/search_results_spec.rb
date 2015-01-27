require 'rails_helper'

describe SearchResults do
  let(:query)             { 'test query' }
  let(:memory_results)    { [] }
  let(:scrapbook_results) { [] }

  subject { SearchResults.new(query) }

  before :each do
    allow(Memory).to receive(:text_search).and_return(memory_results)
    allow(Scrapbook).to receive(:text_search).and_return(scrapbook_results)
  end

  describe '#query' do
    it 'provides the given query' do
      expect(subject.query).to eql(query)
    end
  end

  describe '#memory_results' do
    it 'runs a text search on Memory with the given query' do
      subject.memory_results
      expect(Memory).to have_received(:text_search).with(query)
    end
  end

  describe '#scrapbook_results' do
    it 'runs a text search on Scrapbook with the given query' do
      subject.scrapbook_results
      expect(Scrapbook).to have_received(:text_search).with(query)
    end
  end

  describe '#memory_count' do
    context 'when no memories are found' do
      let(:memory_results) { [] }

      it 'returns the number of memories found' do
        expect(subject.memory_count).to eql(0)
      end
    end

    context 'when one memory is found' do
      let(:memory_results) { ['memory_1'] }
      
      it 'returns the number of memories found' do
        expect(subject.memory_count).to eql(1)
      end
    end

    context 'when more than one memory is found' do
      let(:memory_results) { ['memory_1', 'memory_2'] }
      
      it 'returns the number of memories found' do
        expect(subject.memory_count).to eql(2)
      end
    end
  end

  describe '#scrapbook_count' do
    context 'when no scrapbooks are found' do
      let(:scrapbook_results) { [] }

      it 'returns the number of scrapbooks found' do
        expect(subject.scrapbook_count).to eql(0)
      end
    end

    context 'when one scrapbook is found' do
      let(:scrapbook_results) { ['scrapbook_1'] }
      
      it 'returns the number of scrapbooks found' do
        expect(subject.scrapbook_count).to eql(1)
      end
    end

    context 'when more than one scrapbook is found' do
      let(:scrapbook_results) { ['scrapbook_1', 'scrapbook_2'] }
      
      it 'returns the number of scrapbooks found' do
        expect(subject.scrapbook_count).to eql(2)
      end
    end
  end
end

