require 'rails_helper'

RSpec.describe HomePage do
  before :all do
    @featured_memory               = Fabricate(:approved_photo_memory)
    @featured_scrapbook            = Fabricate(:approved_scrapbook)
    @featured_scrapbook_memories   = Fabricate.times(4, :scrapbook_photo_memory, scrapbook: @featured_scrapbook)
    @featured_scrapbook_memory_ids = @featured_scrapbook_memories.map(&:id).join(',')
  end

  after :all do
    @featured_memory.destroy
    @featured_scrapbook.destroy
    @featured_scrapbook_memories.each(&:destroy)
    User.destroy_all
  end

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

          it 'is valid' do
            expect(subject.errors[:featured_scrapbook]).to be_empty
          end
        end
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
end
