require 'rails_helper'

RSpec.describe HomePage do
  describe 'validation' do
    let(:featured_memory)               { nil }
    let(:featured_scrapbook)            { nil }
    let(:featured_scrapbook_memory_ids) { nil }

    subject {
      Fabricate.build(:home_page,
        featured_memory: featured_memory,
        featured_scrapbook: featured_scrapbook,
        featured_scrapbook_memory_ids: featured_scrapbook_memory_ids
      )
    }

    before { subject.valid? }

    describe 'featured memory' do
      context 'when nil' do
        let(:featured_memory) { nil }

        it 'is invalid' do
          expect(subject.errors[:featured_memory]).to include("can't be blank")
        end
      end

      context 'when not publicly visible' do
        let(:featured_memory) { Fabricate(:pending_memory) }

        it 'is invalid' do
          expect(subject.errors[:featured_memory]).to include("must be publicly visible")
        end
      end

      context 'when publicly visible' do
        let(:featured_memory) { Fabricate(:approved_memory) }

        it 'is valid' do
          expect(subject.errors[:featured_memory]).to be_empty
        end
      end
    end

    describe 'featured scrapbook' do
      context 'when nil' do
        let(:featured_scrapbook) { nil }

        it 'is invalid' do
          expect(subject.errors[:featured_scrapbook]).to include("can't be blank")
        end
      end

      context 'when not publicly visible' do
        let(:featured_scrapbook) { Fabricate(:pending_scrapbook) }

        it 'is invalid' do
          expect(subject.errors[:featured_scrapbook]).to include("must be publicly visible")
        end
      end

      context 'when publicly visible' do
        let(:featured_scrapbook) { Fabricate(:approved_scrapbook) }

        it 'is valid' do
          expect(subject.errors[:featured_scrapbook]).to be_empty
        end
      end
    end

    describe 'featured scrapbook memories' do
      context 'when there are no scrapbook memories' do
        let(:featured_scrapbook_memory_ids) { nil }

        it 'is invalid' do
          expect(subject.errors[:base]).to include('Must have four scrapbook memories picked.')
        end
      end

      context 'when there is one scrapbook memory' do
        let(:featured_scrapbook_memory_ids) { '1' }

        it 'is invalid' do
          expect(subject.errors[:base]).to include('Must have four scrapbook memories picked.')
        end
      end

      context 'when there are two scrapbook memories' do
        let(:featured_scrapbook_memory_ids) { '1,2' }

        it 'is invalid' do
          expect(subject.errors[:base]).to include('Must have four scrapbook memories picked.')
        end
      end

      context 'when there are three scrapbook memories' do
        let(:featured_scrapbook_memory_ids) { '1,2,3' }

        it 'is invalid' do
          expect(subject.errors[:base]).to include('Must have four scrapbook memories picked.')
        end
      end

      context 'when there are four scrapbook memories' do
        let(:featured_scrapbook_memory_ids) { '1,2,3,4' }

        it 'is valid' do
          expect(subject.errors[:base]).not_to include('Must have four scrapbook memories picked.')
        end
      end

      context 'when there are five scrapbook memories' do
        let(:featured_scrapbook_memory_ids) { '1,2,3,4,5' }

        it 'is invalid' do
          expect(subject.errors[:base]).to include('Must have four scrapbook memories picked.')
        end
      end
    end
  end

  describe '.current' do
    before :all do
      @featured_memory               = Fabricate(:approved_photo_memory)
      @featured_scrapbook            = Fabricate(:approved_scrapbook)
      @featured_scrapbook_memory_ids = Fabricate.times(4, :approved_photo_memory).map(&:id).join(',')
    end

    context 'when there are no home pages' do
      it 'returns nil' do
        expect(HomePage.current).to be_nil
      end
    end

    context 'when there is one home page' do
      context 'and it is not published' do
        let!(:home_page) {
          Fabricate(:unpublished_home_page,
            featured_memory: @featured_memory,
            featured_scrapbook: @featured_scrapbook,
            featured_scrapbook_memory_ids: @featured_scrapbook_memory_ids,
            published: false
          )
        }

        it 'returns nil' do
          expect(HomePage.current).to be_nil
        end
      end

      context 'and it is published' do
        let!(:home_page) {
          Fabricate(:unpublished_home_page,
            featured_memory: @featured_memory,
            featured_scrapbook: @featured_scrapbook,
            featured_scrapbook_memory_ids: @featured_scrapbook_memory_ids,
            published: true
          )
        }

        it 'returns the published home page' do
          expect(HomePage.current).to eq(home_page)
        end
      end
    end

    context 'when there is more than one home page' do
      let!(:unpublished_home_page) {
        Fabricate(:unpublished_home_page,
          featured_memory: @featured_memory,
          featured_scrapbook: @featured_scrapbook,
          featured_scrapbook_memory_ids: @featured_scrapbook_memory_ids,
          published: false
        )
      }
      let!(:published_home_page_first) {
        Fabricate(:published_home_page,
            featured_memory: @featured_memory,
            featured_scrapbook: @featured_scrapbook,
            featured_scrapbook_memory_ids: @featured_scrapbook_memory_ids,
            published: true
        )
      }
      let!(:published_home_page_last) {
        Fabricate(:published_home_page,
            featured_memory: @featured_memory,
            featured_scrapbook: @featured_scrapbook,
            featured_scrapbook_memory_ids: @featured_scrapbook_memory_ids,
            published: true
        )
      }

      it 'returns the last published home page' do
        expect(HomePage.current).to eq(published_home_page_last)
      end
    end
  end
end
