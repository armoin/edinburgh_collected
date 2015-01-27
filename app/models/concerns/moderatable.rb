module Moderatable
  extend ActiveSupport::Concern

  included do
    before_create :set_moderation_fields
  end

  def set_moderation_fields
    self.moderation_state ||= ModerationStateMachine::DEFAULT_STATE
  end

  module ClassMethods
    def moderation_record_query
      ModerationRecordQuery.new(self, moderation_record)
    end

    def in_state(state)
      where(moderation_state: state)
    end

    def not_in_state(state)
      where.not(moderation_state: state)
    end

    def moderated
      not_in_state('unmoderated')
    end

    def unmoderated
      in_state('unmoderated')
    end

    def approved
      in_state('approved')
    end

    def rejected
      in_state('rejected')
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

  def reject!(comment='')
    update_state!('rejected', comment)
  end

  def unmoderate!
    update_state!('unmoderated')
  end

  def approved?
    moderation_state == 'approved'
  end

  def unmoderated?
    moderation_state == 'unmoderated'
  end

  private

  def update_state!(state, comment='')
    moderation_records.create!(from_state: moderation_state, to_state: state, comment: comment)
    update_attributes(moderation_state: state, moderation_reason: comment, last_moderated_at: DateTime.now)
  end
end
