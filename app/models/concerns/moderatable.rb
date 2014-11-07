module Moderatable
  extend ActiveSupport::Concern

  module ClassMethods
    def moderation_record_query
      ModerationRecordQuery.new(self, moderation_record)
    end

    def unmoderated
      Memory.find_by_sql(moderation_record_query.query_for('unmoderated'))
    end

    def approved
      Memory.find_by_sql(moderation_record_query.query_for('approved'))
    end

    def rejected
      Memory.find_by_sql(moderation_record_query.query_for('rejected'))
    end

    def moderation_record
      #TODO raise error if not implemented
    end
  end

  def moderation_records
    #TODO raise error if not implemented
  end

  def approve!
    update_state!('approved')
  end

  def reject!(comment)
    update_state!('rejected', comment)
  end

  def unmoderate!
    update_state!('unmoderated')
  end

  def current_state
    state = moderation_records
      .order('created_at DESC')
      .limit(1)
      .first
      .try(:to_state)
    state || ModerationStateMachine::DEFAULT_STATE
  end

  private

  def update_state!(state, comment=nil)
    moderation_records.create!(from_state: current_state, to_state: state, comment: comment)
  end
end
