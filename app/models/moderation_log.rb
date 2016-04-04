class ModerationLog < ActiveRecord::Base
  belongs_to :moderatable, polymorphic: true
  belongs_to :moderated_by, class_name: User

  delegate :valid_state?, to: ModerationStateMachine

  validates :moderatable, :moderated_by, :from_state, :to_state, presence: true
  validate :validate_from_state
  validate :validate_to_state

  private

  def validate_from_state
    validate_state_in(:from_state)
  end

  def validate_to_state
    validate_state_in(:to_state)
  end

  def validate_state_in(field_name)
    errors.add(field_name, 'is not a valid state') unless valid_state?(self.send(field_name))
  end
end
