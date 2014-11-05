require 'rails_helper'

describe ModerationRecordQuery do
  describe '#query_for' do
    context 'Memory' do
      let(:sql) { subject.query_for('unmoderated').to_sql }

      subject { ModerationRecordQuery.new(Memory, MemoryModeration) }

      it 'selects all memory fields' do
        expect(sql).to include(memories_projection)
      end

      it 'selects from the memories table' do
        expect(sql).to include(memories_from)
      end

      it 'left joins the memory_moderations table' do
        expect(sql).to include(memories_first_join)
      end

      it 'left joins the memory_moderations table again to sort records' do
        expect(sql).to include(memories_second_join)
      end

      context "when querying for default state" do
        let(:sql) { subject.query_for(ModerationStateMachine::DEFAULT_STATE).to_sql }

        it 'filters for records with the state or those that have a null state' do
          expect(sql).to include(memories_where_default_state)
        end
      end

      context "when querying for a non-default state" do
        let(:sql) { subject.query_for('approved').to_sql }

        it 'filters for records with the state' do
          expect(sql).to include(memories_where_other_state)
        end
      end
    end
  end
end

def memories_projection
  "SELECT memories.*"
end

def memories_from
  "FROM \"memories\""
end

def memories_first_join
  "LEFT OUTER JOIN \"memory_moderations\" ON \"memories\".\"id\" = \"memory_moderations\".\"memory_id\""
end

def memories_second_join
  "LEFT OUTER JOIN \"memory_moderations\" \"memory_moderations_2\" ON \"memories\".\"id\" = \"memory_moderations_2\".\"memory_id\" AND \"memory_moderations_2\".\"created_at\" > \"memory_moderations\".\"created_at\""
end

def memories_where_default_state
  "WHERE \"memory_moderations_2\".\"id\" IS NULL AND (\"memory_moderations\".\"to_state\" = 'unmoderated' OR \"memory_moderations\".\"to_state\" IS NULL)"
end

def memories_where_other_state
  "WHERE \"memory_moderations_2\".\"id\" IS NULL AND \"memory_moderations\".\"to_state\" = 'approved'"
end

