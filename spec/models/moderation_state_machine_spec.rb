require 'rails_helper'

describe ModerationStateMachine do
  describe '.valid_state?' do
    it 'is true with a valid state' do
      ModerationStateMachine::VALID_STATES.each do |valid_state|
        expect(ModerationStateMachine.valid_state?(valid_state)).to be_truthy
      end
    end

    it 'is false with an invalid state' do
      invalid_state = 'nonsense'
      expect(ModerationStateMachine::VALID_STATES).not_to include(invalid_state)
      expect(ModerationStateMachine.valid_state?(invalid_state)).to be_falsy
    end
  end
end
