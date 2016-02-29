require 'rails_helper'

RSpec.describe HomePage do
  describe 'validation' do
    describe 'featured memory' do
      it 'is invalid when blank' do
        subject.valid?
        expect(subject.errors[:featured_memory]).to include("can't be blank")
      end

      it 'is invalid when not publicly visible' do
        subject.featured_memory = Fabricate(:pending_memory)
        subject.valid?
        expect(subject.errors[:featured_memory]).to include("must be publicly visible")
      end

      it 'is valid when publicly visible' do
        subject.featured_memory = Fabricate(:approved_memory)
        subject.valid?
        expect(subject.errors[:featured_memory]).to be_empty
      end
    end

    describe 'featured scrapbook' do
      it 'is invalid when blank' do
        expect(subject).to be_invalid
        expect(subject.errors[:featured_scrapbook]).to include("can't be blank")
      end

      it 'is invalid when not publicly visible' do
        subject.featured_scrapbook = Fabricate(:pending_scrapbook)
        expect(subject).to be_invalid
        expect(subject.errors[:featured_scrapbook]).to include("must be publicly visible")
      end

      it 'is valid when publicly visible' do
        subject.featured_scrapbook = Fabricate(:approved_scrapbook)
        subject.valid?
        expect(subject.errors[:featured_scrapbook]).to be_empty
      end
    end

    describe 'featured scrapbook memory_ids' do
      it 'is invalid unless there are scrapbook memory ids' do
        subject.valid?
        expect(subject.errors[:featured_scrapbook_memory_ids]).to include("can't be blank")
      end
    end
  end
end
