module Moderatable
  extend ActiveSupport::Concern

  included do
    belongs_to :moderated_by, class: User
    has_many :moderation_logs, as: :moderatable, dependent: :destroy

    before_create :set_moderation_fields

    validates :moderation_reason, presence: true, if: :requires_reason
  end

  def set_moderation_fields
    self.moderation_state ||= ModerationStateMachine::DEFAULT_STATE
  end

  module ClassMethods
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

    def rejected
      in_state('rejected')
    end

    def reported
      in_state('reported')
    end

    def blocked
      in_state('blocked')
    end

    def publicly_visible
      if class_name == 'User'
        where(publicly_visible_sql)
      else
        joins(:user)
          .where(publicly_visible_sql)
      end
    end

    def publicly_visible_sql
      arel_table[:moderation_state].eq('approved')
        .and( User.arel_table[:activation_state].eq('active') )
        .and( User.arel_table[:moderation_state].eq('approved') )
    end

    def by_first_moderated
      order('last_moderated_at')
    end

    def by_last_moderated
      order('last_moderated_at DESC')
    end
  end

  def approve!(approved_by)
    update_state!('approved', approved_by)
  end

  def reject!(rejected_by, comment='')
    update_state!('rejected', rejected_by, comment)
  end

  def block!(blocked_by)
    update_state!('blocked', blocked_by)
  end

  def report!(reported_by, comment='')
    update_state!('reported', reported_by, comment)
  end

  def unmoderate!(unmoderated_by)
    update_state!('unmoderated', unmoderated_by)
  end

  def approved?
    if is_a?(User)
      moderation_state == 'approved' && activation_state == 'active'
    else
      moderation_state == 'approved' && user.approved?
    end
  end

  def unmoderated?
    moderation_state == 'unmoderated'
  end

  def blocked?
    moderation_state == 'blocked'
  end

  private

  def update_state!(state, moderated_by, comment='')
    moderation_logs.create!(from_state: moderation_state, to_state: state, moderated_by: moderated_by, comment: comment)
    update_attributes(moderation_state: state, moderated_by: moderated_by, moderation_reason: comment, last_moderated_at: DateTime.now)
  end

  def requires_reason
    ModerationStateMachine::REQUIRE_REASON.include?(moderation_state)
  end
end
