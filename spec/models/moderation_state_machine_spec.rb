require 'rails_helper'

describe ModerationStateMachine do
  describe '.valid_state?' do
    it 'is true with a valid state' do
      %w(unmoderated approved rejected reported blocked deleted).each do |state|
        expect(ModerationStateMachine.valid_state?(state)).to be_truthy, "#{state} is not a valid state"
      end
    end

    it 'is false with an invalid state' do
      invalid_state = 'nonsense'
      expect(ModerationStateMachine::VALID_STATES).not_to include(invalid_state)
      expect(ModerationStateMachine.valid_state?(invalid_state)).to be_falsy
    end
  end
end
