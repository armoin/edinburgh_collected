class ModerationStateMachine
  VALID_STATES = %w(unmoderated approved rejected)
  DEFAULT_STATE = 'unmoderated'

  def self.valid_state?(state)
    VALID_STATES.include?(state)
  end
end

