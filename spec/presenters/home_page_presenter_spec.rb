require 'rails_helper'

RSpec.describe HomePagePresenter do
  let(:hero_image_path)    { 'path/to/hero_image.jpg' }
  let!(:user)              { Fabricate.build(:active_user, id: 123) }
  let(:memory)             { Fabricate.build(:photo_memory, id: 456, user: user) }
  let(:scrapbook)          { Fabricate.build(:scrapbook, id: 789, user: user) }
  let(:scrapbook_memories) { Array.new(4) { |n| Fabricate.build(:photo_memory, id: n+1) } }

  let(:homepage_data) {
    OpenStruct.new(
      hero_image: hero_image_path,
      featured_memory_data: {
        id: memory.id,
        title: memory.title,
        user: {
          id: user.id,
          name: user.name
        },
        year: memory.year
      },
      featured_scrapbook_data: {
        id: scrapbook.id,
        memories: [
          {
            id: 6,
            image_url: 'my_first_image.jpg',
            title: 'Title 1'
          },
          {
            id: 7,
            image_url: 'my_second_image.jpg',
            title: 'Title 2'
          },
          {
            id: 8,
            image_url: 'my_third_image.jpg',
            title: 'Title 3'
          },
          {
            id: 9,
            image_url: 'my_fourth_image.jpg',
            title: 'Title 4'
          },
        ],
        memory_ids: scrapbook_memories.map(&:id),
        title: scrapbook.title,
        user: {
          id: user.id,
          name: user.name
        }
      }
    )
  }

  subject { HomePagePresenter.new(homepage_data) }

  before :each do
    allow(Memory).to receive(:find).with(456) { memory }
    allow(Scrapbook).to receive(:find).with(789) { scrapbook }
    allow(scrapbook.memories).to receive(:where) { scrapbook_memories }
  end

  describe '#hero_image_path' do
    it 'provides the given hero_image url' do
      expect(subject.hero_image_path).to eql(hero_image_path)
    end
  end

  describe '#featured_memory' do
    context 'when on production' do
      before :each do
        allow(ENV).to receive(:[]).with('HOST').and_return('https://edinburghcollected.org')
      end

      it 'looks for the memory' do
        subject
        expect(Memory).to have_received(:find).with(456)
      end

      it 'is a Memory' do
        expect(subject.featured_memory).to be_a(Memory)
      end

      it 'has an ID' do
        expect(subject.featured_memory.id).to eql(memory.id)
      end

      it 'has a title' do
        expect(subject.featured_memory.title).to eql(memory.title)
      end

      it 'has a user' do
        expect(subject.featured_memory.user).to be_present
        expect(subject.featured_memory.user.id).to eql(user.id)
        expect(subject.featured_memory.user.name).to eql(user.name)
      end

      it 'has a year' do
        expect(subject.featured_memory.year).to eql(memory.year)
      end

      describe 'source_url' do
        it 'is relative' do
          expect(subject.featured_memory.source_url(:thumb)).to start_with('/uploads')
        end

        it 'provides the thumbnail version' do
          expect(subject.featured_memory.source_url(:thumb)).to end_with('thumb_test.jpg')
        end
      end
    end

    context 'when not on production' do
      it 'does not look for the memory' do
        subject
        expect(Memory).not_to have_received(:find)
      end

      it 'is a FakeMemory' do
        expect(subject.featured_memory).to be_a(FakeMemory)
      end

      it 'has an ID' do
        expect(subject.featured_memory.id).to eql(memory.id)
      end

      it 'has a title' do
        expect(subject.featured_memory.title).to eql(memory.title)
      end

      it 'has a user' do
        expect(subject.featured_memory.user).to be_present
        expect(subject.featured_memory.user.id).to eql(user.id)
        expect(subject.featured_memory.user.name).to eql(user.name)
      end

      it 'has a year' do
        expect(subject.featured_memory.year).to eql(memory.year)
      end

      describe 'source_url' do
        it 'is nil ' do
          expect(subject.featured_memory.source_url(:thumb)).to be_nil
        end
      end
    end
  end

  describe '#featured_scrapbook' do
    context 'when on production' do
      before :each do
        allow(ENV).to receive(:[]).with('HOST').and_return('https://edinburghcollected.org')
      end

      it 'looks for the scrapbook' do
        subject
        expect(Scrapbook).to have_received(:find).with(789)
      end

      it 'is a Scrapbook' do
        expect(subject.featured_scrapbook).to be_a(Scrapbook)
      end

      it 'has an ID' do
        expect(subject.featured_scrapbook.id).to eql(scrapbook.id)
      end

      it 'has a title' do
        expect(subject.featured_scrapbook.title).to eql(scrapbook.title)
      end

      it 'has a user' do
        expect(subject.featured_scrapbook.user).to be_present
        expect(subject.featured_scrapbook.user.id).to eql(user.id)
        expect(subject.featured_scrapbook.user.name).to eql(user.name)
      end
    end

    context 'when not on production' do
      it 'does not look for the scrapbook' do
        subject
        expect(Scrapbook).not_to have_received(:find)
      end

      it 'is an OpenStruct' do
        expect(subject.featured_scrapbook).to be_a(OpenStruct)
      end

      it 'has an ID' do
        expect(subject.featured_scrapbook.id).to eql(scrapbook.id)
      end

      it 'has a title' do
        expect(subject.featured_scrapbook.title).to eql(scrapbook.title)
      end

      it 'has a user' do
        expect(subject.featured_scrapbook.user).to be_present
        expect(subject.featured_scrapbook.user.id).to eql(user.id)
        expect(subject.featured_scrapbook.user.name).to eql(user.name)
      end
    end
  end

  describe '#featured_scrapbook_memories' do
    context 'when on production' do
      before :each do
        allow(ENV).to receive(:[]).with('HOST').and_return('https://edinburghcollected.org')
      end

      it 'looks for the requested memories' do
        subject
        expect(scrapbook.memories).to have_received(:where).with(id: scrapbook_memories.map(&:id))
      end

      it 'is a collection of 4 Memory instances' do
        expect(subject.featured_scrapbook_memories.count).to eq(4)
        expect(subject.featured_scrapbook_memories.all? {|m| m.is_a?(Memory)}).to eq(true)
      end

      describe 'a scrapbook memory' do
        let(:scrapbook_memory) { subject.featured_scrapbook_memories.first }

        it 'has an ID' do
          expect(scrapbook_memory.id).to eql(scrapbook_memories.first.id)
        end

        it 'has a title' do
          expect(scrapbook_memory.title).to eql(scrapbook_memories.first.title)
        end

        describe 'source_url' do
          it 'is relative' do
            expect(scrapbook_memory.source_url(:thumb)).to start_with('/uploads')
          end

          it 'provides the thumbnail version' do
            expect(scrapbook_memory.source_url(:thumb)).to end_with('thumb_test.jpg')
          end
        end
      end
    end

    context 'when not on production' do
      it 'does not look for the requested memories' do
        subject
        expect(scrapbook.memories).not_to have_received(:where)
      end

      it 'is a collection of 4 FakeMemory instances' do
        expect(subject.featured_scrapbook_memories.count).to eq(4)
        expect(subject.featured_scrapbook_memories.all? {|m| m.is_a?(FakeMemory)}).to eq(true)
      end

      describe 'a scrapbook memory' do
        let(:scrapbook_memory) { subject.featured_scrapbook_memories.first }

        it 'has an ID' do
          expect(scrapbook_memory.id).to eql(6)
        end

        it 'has a title' do
          expect(scrapbook_memory.title).to eql('Title 1')
        end

        describe 'source_url' do
          it 'is absolute' do
            expect(scrapbook_memory.source_url(:thumb)).to start_with('https://')
          end

          it 'provides the thumbnail version' do
            expect(scrapbook_memory.source_url(:thumb)).to end_with('thumb_my_first_image.jpg')
          end
        end
      end
    end
  end

  describe '#memory_url' do
    context 'when on production' do
      before :each do
        allow(ENV).to receive(:[]).with('HOST').and_return('https://edinburghcollected.org')
      end

      it 'provides a relative url' do
        expect(subject.memory_url(456)).to eq('/memories/456')
      end
    end

    context 'when not on production' do
      it 'provides an absolute url to the production server' do
        expect(subject.memory_url(456)).to eq('https://edinburghcollected.org/memories/456')
      end
    end
  end

  describe '#scrapbook_url' do
    context 'when on production' do
      before :each do
        allow(ENV).to receive(:[]).with('HOST').and_return('https://edinburghcollected.org')
      end

      it 'provides a relative url' do
        expect(subject.scrapbook_url).to eq('/scrapbooks/789')
      end
    end

    context 'when not on production' do
      it 'provides an absolute url to the production server' do
        expect(subject.scrapbook_url).to eq('https://edinburghcollected.org/scrapbooks/789')
      end
    end
  end

  describe '#user_memories_url' do
    context 'when on production' do
      before :each do
        allow(ENV).to receive(:[]).with('HOST').and_return('https://edinburghcollected.org')
      end

      it 'provides a relative url' do
        expect(subject.user_memories_url).to eq("/users/123/memories")
      end
    end

    context 'when not on production' do
      it 'provides an absolute url to the production server' do
        expect(subject.user_memories_url).to eq('https://edinburghcollected.org/users/123/memories')
      end
    end
  end

  describe '#user_scrapbooks_url' do
    context 'when on production' do
      before :each do
        allow(ENV).to receive(:[]).with('HOST').and_return('https://edinburghcollected.org')
      end

      it 'provides a relative url' do
        expect(subject.user_scrapbooks_url).to eq("/users/123/scrapbooks")
      end
    end

    context 'when not on production' do
      it 'provides an absolute url to the production server' do
        expect(subject.user_scrapbooks_url).to eq('https://edinburghcollected.org/users/123/scrapbooks')
      end
    end
  end
end
