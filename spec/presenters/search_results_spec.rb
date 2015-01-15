require 'rails_helper'

describe SearchResults do
  let(:model) { 'memories' }
  let(:query) { 'test query' }
  let(:page)  { '1' }

  subject { SearchResults.new(model, query, page) }

  describe '#query' do
    it 'provides the given query' do
      expect(subject.query).to eql(query)
    end
  end

  describe '#paged_results' do
    context 'when searching for memories' do
      let(:model) { 'memories' }

      context 'when no results are found' do
        it 'provides an empty paged array' do
          expect(subject.paged_results).to respond_to(:current_page)
          expect(subject.paged_results.length).to eql(0)
        end
      end

      context 'when results are found' do
        before :each do
          Fabricate.times(1, :approved_memory, title: query)
        end

        it 'provides a paged memories array' do
          expect(subject.paged_results).to respond_to(:current_page)
          expect(subject.paged_results.length).to eql(1)
          expect(subject.paged_results.first).to be_a(Memory)
        end
      end
    end

    context 'when searching for scrapbooks' do
      let(:model) { 'scrapbooks' }

      context 'when no results are found' do
        it 'provides an empty paged array' do
          expect(subject.paged_results).to respond_to(:current_page)
          expect(subject.paged_results.length).to eql(0)
        end
      end

      context 'when results are found' do
        before :each do
          Fabricate.times(1, :scrapbook, title: query)
        end

        it 'provides a paged scrapbooks array' do
          expect(subject.paged_results).to respond_to(:current_page)
          expect(subject.paged_results.length).to eql(1)
          expect(subject.paged_results.first).to be_a(Scrapbook)
        end
      end
    end
  end

  describe '#memory_count' do
    context 'when no memories are found' do
      it 'returns the number of memories found' do
        expect(subject.memory_count).to eql(0)
      end
    end

    context 'when one memory is found' do
      before :each do
        Fabricate.times(1, :approved_memory, title: query)
      end

      it 'returns the number of memories found' do
        expect(subject.memory_count).to eql(1)
      end
    end

    context 'when more than one memory is found' do
      before :each do
        Fabricate.times(2, :approved_memory, title: query)
      end

      it 'returns the number of memories found' do
        expect(subject.memory_count).to eql(2)
      end
    end
  end

  describe '#scrapbook_count' do
    context 'when no scrapbooks are found' do
      it 'returns the number of scrapbooks found' do
        expect(subject.scrapbook_count).to eql(0)
      end
    end

    context 'when one scrapbook is found' do
      before :each do
        Fabricate.times(1, :scrapbook, title: query)
      end

      it 'returns the number of scrapbooks found' do
        expect(subject.scrapbook_count).to eql(1)
      end
    end

    context 'when more than one scrapbook is found' do
      before :each do
        Fabricate.times(2, :scrapbook, title: query)
      end

      it 'returns the number of scrapbooks found' do
        expect(subject.scrapbook_count).to eql(2)
      end
    end
  end
end

