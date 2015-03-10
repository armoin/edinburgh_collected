require 'rails_helper'

describe UserMemoriesPresenter do
  let(:requested_user) { Fabricate.build(:active_user, id: 123) }
  let(:other_user)     { Fabricate.build(:active_user, id: 456) }
  let(:current_user)   { nil }
  let(:page)           { nil }

  subject { UserMemoriesPresenter.new(requested_user, current_user, page) }

  describe '#requested_user' do
    it 'returns the provided requested user' do
      expect(subject.requested_user).to eql(requested_user)
    end
  end

  describe '#page_title' do
    context 'when user is not logged in' do
      let(:current_user) { nil }

      it "returns 'Your memories'" do
        expect(subject.page_title).to eql("#{requested_user.screen_name.possessive} memories")
      end
    end

    context 'when user is logged in' do
      context 'and the requested user is not the current user' do
        let(:current_user) { other_user }

        it "returns 'Your memories'" do
          expect(subject.page_title).to eql("#{requested_user.screen_name.possessive} memories")
        end
      end

      context 'and the requested user is the current user' do
        let(:current_user) { requested_user }

        it "returns 'Your memories'" do
          expect(subject.page_title).to eql('Your memories')
        end
      end
    end
  end

  describe '#memories_count' do
    before :each do
      Fabricate(:approved_memory, user: requested_user)
      Fabricate(:memory, user: requested_user)
    end

    context "when the requested user is the current user" do
      let(:current_user) { requested_user }

      it "provides the count of all the current user's memories" do
        expect(subject.memories_count).to eql(2)
      end
    end

    context "when the requested user is not the current user" do
      let(:current_user) { other_user }

      it "provides the count of the requested user's approved memories only" do
        expect(subject.memories_count).to eql(1)
      end
    end
  end

  describe '#scrapbooks_count' do
    before :each do
      Fabricate(:approved_scrapbook, user: requested_user)
      Fabricate(:scrapbook, user: requested_user)
    end

    context "when the requested user is the current user" do
      let(:current_user) { requested_user }

      it "provides the count of all the current user's scrapbooks" do
        expect(subject.scrapbooks_count).to eql(2)
      end
    end

    context "when the requested user is not the current user" do
      let(:current_user) { other_user }

      it "provides the count of the requested user's approved scrapbooks only" do
        expect(subject.scrapbooks_count).to eql(1)
      end
    end
  end

  describe '#can_add_memories?' do
    context 'when the user is not logged in' do
      let(:current_user) { nil }

      it 'is false' do
        expect(subject.can_add_memories?).to be_falsy
      end
    end

    context 'when the user is logged in' do
      context 'but not as the requested user' do
        let(:current_user) { other_user }

        it 'is false' do
          expect(subject.can_add_memories?).to be_falsy
        end
      end

      context 'as the requested user' do
        let(:current_user) { requested_user }

        it 'is true' do
          expect(subject.can_add_memories?).to be_truthy
        end
      end
    end
  end

  describe '#paged_memories' do
    let!(:approved_memory)   { Fabricate(:approved_memory, user: requested_user, created_at: 5.days.ago) }
    let!(:unapproved_memory) { Fabricate(:memory, user: requested_user, created_at: 2.days.ago) }

    it "is paginated" do
      expect(subject.paged_memories).to respond_to(:current_page)
    end

    context "when the requested user is the current user" do
      let(:current_user) { requested_user }

      it "provides all of the current user's memories" do
        expect(subject.paged_memories.length).to eql(2)
        expect(subject.paged_memories).to include(approved_memory)
        expect(subject.paged_memories).to include(unapproved_memory)
      end

      it "is ordered by the most recent" do
        expect(subject.paged_memories.first).to eql(unapproved_memory)
        expect(subject.paged_memories.last).to eql(approved_memory)
      end
    end

    context "when the requested user is not the current user" do
      let(:current_user) { other_user }

      it "provides the requested user's approved memories only" do
        expect(subject.paged_memories.length).to eql(1)
        expect(subject.paged_memories).to include(approved_memory)
        expect(subject.paged_memories).not_to include(unapproved_memory)
      end
    end
  end
end