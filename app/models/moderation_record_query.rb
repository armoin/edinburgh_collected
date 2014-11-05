class ModerationRecordQuery
  def initialize(model, moderation_record)
    @model = model
    @moderation_record = moderation_record
    @table_name = model.name.tableize
    @foreign_key = model.name.foreign_key.to_sym
  end

  def query_for(state)
    model_table
      .project("#{@table_name}.*")
      .join(moderation_records_1, Arel::Nodes::OuterJoin)
      .on(id_matches_fk_for(moderation_records_1))
      .join(moderation_records_2, Arel::Nodes::OuterJoin)
      .on(id_matches_fk_for(moderation_records_2).and(sort_latest))
      .where( latest_record.and(state_is(state)))
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

