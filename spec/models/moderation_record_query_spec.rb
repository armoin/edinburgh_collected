require 'rails_helper'

describe ModerationRecordQuery do
  subject { ModerationRecordQuery.new(Memory, MemoryModeration) }

  describe '#first_join' do
    context 'Memory' do
      let(:sql) { subject.first_join }

      it 'left joins the memory_moderations table' do
        expect(sql).to include(memories_first_join)
      end
    end
  end

  describe '#second_join' do
    context 'Memory' do
      let(:sql) { subject.second_join }

      it 'left joins the memory_moderations table again to sort records' do
        expect(sql).to include(memories_second_join)
      end
    end
  end

  describe '#where' do
    context 'Memory' do
      context "when querying for default state" do
        let(:sql) { subject.where(ModerationStateMachine::DEFAULT_STATE) }

        it 'filters for records with the state or those that have a null state' do
          expect(sql).to include(memories_where_default_state)
        end
      end

      context "when querying for a non-default state" do
        let(:sql) { subject.where('approved') }

        it 'filters for records with the state' do
          expect(sql).to include(memories_where_other_state)
        end
      end
    end
  end
end

def memories_first_join
  "LEFT OUTER JOIN \"memory_moderations\" ON \"memories\".\"id\" = \"memory_moderations\".\"memory_id\""
end

def memories_second_join
  "LEFT OUTER JOIN \"memory_moderations\" \"memory_moderations_2\" ON \"memories\".\"id\" = \"memory_moderations_2\".\"memory_id\" AND \"memory_moderations_2\".\"created_at\" > \"memory_moderations\".\"created_at\""
end

def memories_where_default_state
  "\"memory_moderations_2\".\"id\" IS NULL AND (\"memory_moderations\".\"to_state\" = 'unmoderated' OR \"memory_moderations\".\"to_state\" IS NULL)"
end

def memories_where_other_state
  "\"memory_moderations_2\".\"id\" IS NULL AND \"memory_moderations\".\"to_state\" = 'approved'"
end

