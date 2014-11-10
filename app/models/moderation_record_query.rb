class ModerationRecordQuery
  def initialize(model, moderation_record)
    @model = model
    @moderation_record = moderation_record
    @table_name = model.name.tableize
    @foreign_key = model.name.foreign_key.to_sym
  end

  def first_join
    constraints = model_table.create_on(
      id_matches_fk_for(moderation_records_1)
    )
    model_table.create_join(moderation_records_1, constraints, Arel::Nodes::OuterJoin).to_sql
  end

  def second_join
    constraints = model_table.create_on(
      id_matches_fk_for(moderation_records_2).and(sort_latest)
    )
    model_table.create_join(moderation_records_2, constraints, Arel::Nodes::OuterJoin).to_sql
  end

  def where(state)
    latest_record.and(state_is(state)).to_sql
  end

  private

  def model_table
    @model.arel_table
  end

  def moderation_records_1
    @moderation_record.arel_table
  end

  def moderation_records_2
    moderation_records_1.alias
  end

  def id_matches_fk_for(moderation_records)
    model_table[:id].eq(moderation_records[@foreign_key])
  end

  def sort_latest
    moderation_records_2[:created_at].gt(moderation_records_1[:created_at])
  end

  def latest_record
    moderation_records_2[:id].eq(nil)
  end

  def state_is(state)
    state_finder = moderation_records_1[:to_state].eq(state)
    return state_finder unless state == ModerationStateMachine::DEFAULT_STATE
    state_finder.or( moderation_records_1[:to_state].eq(nil) )
  end
end

