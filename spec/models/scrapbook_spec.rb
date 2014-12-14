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

  describe 'searching' do
    before :each do
      @term_in_title       = Fabricate(:scrapbook, title: 'Edinburgh Castle test')
      @term_in_description = Fabricate(:scrapbook, description: 'This is an Edinburgh Castle test')
      @terms_not_found     = Fabricate(:scrapbook, title: 'test', description: 'test')
    end

    let(:results) { Scrapbook.text_search(terms) }

    context 'when no terms are given' do
      let(:terms) { nil }

      it 'returns all records' do
        expect(results.count(:all)).to eql(3)
      end
    end

    context 'when blank terms are given' do
      let(:terms) { '' }

      it 'returns all records' do
        expect(results.count(:all)).to eql(3)
      end
    end

    context 'text fields' do
      let(:terms) { 'castle' }

      it 'returns all records matching the given query' do
        expect(results.count(:all)).to eql(2)
      end

      it "includes records where title matches" do
        expect(results).to include(@term_in_title)
      end

      it "includes records where description matches" do
        expect(results).to include(@term_in_description)
      end
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

  describe '#update' do
    let(:initial_params) {{ title: 'new title' }}
    let(:params)         { initial_params }

    subject { Fabricate(:scrapbook) }

    before :each do
      allow(ScrapbookMemory).to receive(:reorder_for_scrapbook)
      allow(ScrapbookMemory).to receive(:remove_from_scrapbook)
      subject.update(params)
    end

    describe "ordering" do
      context 'when there is no ordering' do
        it 'does not update the ordering' do
          expect(ScrapbookMemory).not_to have_received(:reorder_for_scrapbook)
        end
      end

      context 'when there is an empty ordering' do
        let(:params) { initial_params.merge({ordering: ''}) }

        it 'does not update the ordering' do
          expect(ScrapbookMemory).not_to have_received(:reorder_for_scrapbook)
        end
      end

      context 'when there is an ordering' do
        let(:params) { initial_params.merge({ordering: '1,2,3'}) }

        it 'updates the ordering' do
          expect(ScrapbookMemory).to have_received(:reorder_for_scrapbook).with(subject, %w(1 2 3))
        end
      end
    end

    describe "deleted" do
      context 'when there are no deleted' do
        it 'does not remove the deleted' do
          expect(ScrapbookMemory).not_to have_received(:remove_from_scrapbook)
        end
      end

      context 'when there is an empty deleted' do
        let(:params) { initial_params.merge({deleted: ''}) }

        it 'does not remove the deleted' do
          expect(ScrapbookMemory).not_to have_received(:remove_from_scrapbook)
        end
      end

      context 'when there is a deleted' do
        let(:params) { initial_params.merge({deleted: '4,5'}) }

        it 'removes the deleted' do
          expect(ScrapbookMemory).to have_received(:remove_from_scrapbook).with(subject, %w(4 5))
        end
      end
    end

    context "when there is ordering and deleted" do
      let(:params) { initial_params.merge({
        ordering: '1,2,3',
        deleted: '4,5'
      })}


      it 'passes the rest of the params upstream' do
        subject.update(params)
        expect(subject.title).to eql('new title')
      end

      it "is false if invalid" do
        params[:title] = nil
        expect(subject.update(params)).to be_falsy
      end

      it "is false if there are errors" do
        stub_errors = double(messages: ['test error'], clear: true, empty?: true)
        allow(subject).to receive(:errors).and_return(stub_errors)
        expect(subject.update(params)).to be_falsy
      end

      it "is true if valid and there are no errors" do
        expect(subject.update(params)).to be_truthy
      end
    end
  end
end
