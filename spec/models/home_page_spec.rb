require 'rails_helper'

RSpec.describe HomePage do
  include_context 'home_page'

  describe 'validation' do
    let(:featured_memory)               { nil }
    let(:featured_scrapbook)            { nil }
    let(:featured_scrapbook_memory_ids) { nil }
    let(:hero_image)                    { nil }

    subject {
      Fabricate.build(:home_page,
        featured_memory: featured_memory,
        featured_scrapbook: featured_scrapbook,
        featured_scrapbook_memory_ids: featured_scrapbook_memory_ids,
        hero_image: hero_image
      )
    }

    before { subject.valid? }

    describe 'featured memory' do
      context 'when nil' do
        let(:featured_memory) { nil }

        it 'is invalid' do
          expect(subject.errors[:featured_memory]).to include('must be a valid memory ID')
        end
      end

      context 'given featured_memory_id does not belong to an existing memory' do

      end

      context 'when not publicly visible' do
        let(:featured_memory) { Fabricate(:pending_memory) }

        it 'is invalid' do
          expect(subject.errors[:featured_memory]).to include('must be publicly visible')
        end
      end

      context 'when publicly visible' do
        context 'and not a picture memory' do
          let(:featured_memory) { Fabricate(:approved_written_memory) }

          it 'is invalid' do
            expect(subject.errors[:featured_memory]).to include('must be a photo memory')
          end
        end

        context 'and is a picture memory' do
          let(:featured_memory) { Fabricate(:approved_photo_memory) }

          it 'is valid' do
            expect(subject.errors[:featured_memory]).to be_empty
          end
        end
      end
    end

    describe 'featured scrapbook' do
      context 'when nil' do
        let(:featured_scrapbook) { nil }

        it 'is invalid' do
          expect(subject.errors[:featured_scrapbook]).to include('must be a valid scrapbook ID')
        end
      end

      context 'when not publicly visible' do
        let(:featured_scrapbook) { Fabricate(:pending_scrapbook) }

        it 'is invalid' do
          expect(subject.errors[:featured_scrapbook]).to include('must be publicly visible')
        end
      end

      context 'when publicly visible' do
        context 'but does not have enough picture memories' do
          let(:featured_scrapbook) { Fabricate(:approved_scrapbook) }

          it 'is invalid' do
            expect(subject.errors[:featured_scrapbook]).to include('must have at least 4 picture memories')
          end
        end

        context 'and has enough picture memories' do
          let(:featured_scrapbook) {
            scrapbook = Fabricate(:approved_scrapbook)
            Fabricate.times(4, :scrapbook_photo_memory, scrapbook: scrapbook)
            scrapbook
          }
          1
          it 'is valid' do
            expect(subject.errors[:featured_scrapbook]).to be_empty
          end
        end
      end
    end

    describe 'featured scrapbook memories' do
      context 'when there are no scrapbook memories' do
        let(:featured_scrapbook_memory_ids) { nil }

        it 'is invalid' do
          expect(subject.errors[:base]).to include('Must have 4 scrapbook memories picked.')
        end
      end

      context 'when there is one scrapbook memory' do
        let(:featured_scrapbook_memory_ids) { '1' }

        it 'is invalid' do
          expect(subject.errors[:base]).to include('Must have 4 scrapbook memories picked.')
        end
      end

      context 'when there are two scrapbook memories' do
        let(:featured_scrapbook_memory_ids) { '1,2' }

        it 'is invalid' do
          expect(subject.errors[:base]).to include('Must have 4 scrapbook memories picked.')
        end
      end

      context 'when there are three scrapbook memories' do
        let(:featured_scrapbook_memory_ids) { '1,2,3' }

        it 'is invalid' do
          expect(subject.errors[:base]).to include('Must have 4 scrapbook memories picked.')
        end
      end

      context 'when there are four scrapbook memories' do
        let(:featured_scrapbook) { Fabricate(:approved_scrapbook) }

        context 'but not all belong to the featured scrapbook' do
          let(:featured_scrapbook_memory_ids) {
            scrapbook_memories =  Fabricate.times(3, :scrapbook_photo_memory, scrapbook: featured_scrapbook)
            scrapbook_memories += Fabricate.times(1, :scrapbook_photo_memory)
            scrapbook_memories.map(&:id).join(',')
          }

          it 'is invalid' do
            expect(subject.errors[:base]).to include('All scrapbook memories must belong to the featured scrapbook.')
          end
        end

        context 'and they all belong to the featured scrapbook' do
          let(:featured_scrapbook_memory_ids) {
            Fabricate.times(4, :scrapbook_photo_memory, scrapbook: featured_scrapbook).map(&:id).join(',')
          }

          it 'is valid' do
            expect(subject.errors[:base]).to be_empty
          end
        end
      end

      context 'when there are five scrapbook memories' do
        let(:featured_scrapbook_memory_ids) { '1,2,3,4,5' }

        it 'is invalid' do
          expect(subject.errors[:base]).to include('Must have 4 scrapbook memories picked.')
        end
      end
    end
  end

  describe '.published' do
    context 'when there are no home pages' do
      it 'is empty' do
        expect(HomePage.published).to be_empty
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

        it 'is empty' do
          expect(HomePage.published).to be_empty
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
          expect(HomePage.published.count).to eql(1)
          expect(HomePage.published).to include(home_page)
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

      it 'returns the all published home pages' do
        expect(HomePage.published.count).to eql(2)
        expect(HomePage.published).to include(published_home_page_first)
        expect(HomePage.published).to include(published_home_page_last)
        expect(HomePage.published).not_to include(unpublished_home_page)
      end
    end
  end

  describe '.current' do
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

  describe '#featured_scrapbook_memories' do
    subject(:home_page) do
      HomePage.new(
        featured_memory: @featured_memory,
        featured_scrapbook: @featured_scrapbook,
        featured_scrapbook_memory_ids: featured_scrapbook_memory_ids
      )
    end

    context 'when there are no featured_scrapbook_memory_ids' do
      let(:featured_scrapbook_memory_ids) { nil }

      it 'returns an empty array' do
        expect(home_page.featured_scrapbook_memories).to be_empty
      end
    end

    context 'when there is one featured_scrapbook_memory_id' do
      context 'and it belongs to the featured scrapbook' do
        let(:featured_scrapbook_memory_ids) { @featured_scrapbook_memories.first.id.to_s }

        it 'returns the associated memory' do
          memories = home_page.featured_scrapbook_memories
          expect(memories.count).to eq(1)
          expect(memories).to include(@featured_scrapbook_memories[0].memory)
        end
      end

      context 'but it does not belong to the featured scrapbook' do
        let(:featured_scrapbook_memory_ids) { Fabricate(:scrapbook_photo_memory).id.to_s }

        it 'returns an empty array' do
          memories = home_page.featured_scrapbook_memories
          expect(memories).to be_empty
        end
      end
    end

    context 'when there are four featured_scrapbook_memory_ids' do
      context 'and they all belong to the featured scrapbook' do
        let(:featured_scrapbook_memory_ids) { @featured_scrapbook_memory_ids }

        it 'returns the associated memories' do
          memories = home_page.featured_scrapbook_memories
          expect(memories.count).to eq(4)
          expect(memories).to include(@featured_scrapbook_memories[0].memory)
          expect(memories).to include(@featured_scrapbook_memories[1].memory)
          expect(memories).to include(@featured_scrapbook_memories[2].memory)
          expect(memories).to include(@featured_scrapbook_memories[3].memory)
        end
      end

      context 'but not all belong to the featured scrapbook' do
        let(:other_featured_scrapbook_memory) { Fabricate(:scrapbook_photo_memory) }
        let(:featured_scrapbook_memory_ids) do
          ids = @featured_scrapbook_memory_ids.split(',').take(3)
          ids << other_featured_scrapbook_memory.id
          ids.join(',')
        end

        it 'returns the associated memories' do
          memories = home_page.featured_scrapbook_memories
          expect(memories.count).to eq(3)
          expect(memories).to include(@featured_scrapbook_memories[0].memory)
          expect(memories).to include(@featured_scrapbook_memories[1].memory)
          expect(memories).to include(@featured_scrapbook_memories[2].memory)
          expect(memories).not_to include(other_featured_scrapbook_memory.memory)
        end
      end
    end
  end

  describe 'hero image' do
    it 'has an uploader for the hero image' do
      expect(described_class.uploaders).to have_key(:hero_image)
    end

    it_behaves_like 'an image manipulator'
  end

  describe '#state' do
    it 'returns "draft" when not published' do
      expect(HomePage.new(published: false).state).to eq('draft')
    end

    it 'returns "live" when published' do
      expect(HomePage.new(published: true).state).to eq('live')
    end
  end

  describe '#publish' do
    let(:published_home_page) { double(update_column: true) }

    before :each do
      allow(HomePage).to receive(:published).and_return([published_home_page])
    end

    context 'when the home_page is not persisted' do
      it 'returns false' do
        expect(subject.publish).to be_falsy
      end

      it 'does not unpublish any existing published home_pages' do
        subject.publish
        expect(published_home_page).not_to have_received(:update_column).with(:published, false)
      end

      it 'is not published' do
        subject.publish
        expect(subject).not_to be_published
      end
    end

    context 'when the home_page is persisted' do
      let(:featured_scrapbook_memory_ids) { @featured_scrapbook_memory_ids }

      subject do
        Fabricate(:home_page,
          featured_memory: @featured_memory,
          featured_scrapbook: @featured_scrapbook,
          featured_scrapbook_memory_ids: featured_scrapbook_memory_ids
        )
      end

      context 'but it does not have enough scrapbook memories selected' do
        let(:featured_scrapbook_memory_ids) { '' }

        it 'returns false' do
          expect(subject.publish).to be_falsy
        end

        it 'does not unpublish any existing published home_pages' do
          subject.publish
          expect(published_home_page).not_to have_received(:update_column).with(:published, false)
        end

        it 'is not published' do
          subject.publish
          expect(subject).not_to be_published
        end
      end

      context 'and it has enough scrapbook memories selected' do
        let(:featured_scrapbook_memory_ids) { @featured_scrapbook_memory_ids }

        it 'returns true' do
          expect(subject.publish).to be_truthy
        end

        it 'unpublishes any existing published home_pages' do
          subject.publish
          expect(published_home_page).to have_received(:update_column).with(:published, false)
        end

        it 'is published' do
          subject.publish
          expect(subject).to be_published
        end
      end
    end
  end
end
