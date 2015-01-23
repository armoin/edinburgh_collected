class Memory < ActiveRecord::Base; has_many :memory_moderations; end
class MemoryModeration < ActiveRecord::Base; belongs_to :memory; end

class UpdateMemoriesWithModerationData < ActiveRecord::Migration
  def up
    Memory.all.each do |memory|
      last_moderation = memory.memory_moderations.last
      if last_moderation
        memory.update_attributes!(moderation_state: last_moderation.to_state, moderation_reason: last_moderation.comment, last_moderated_at: last_moderation.updated_at)
      else
        memory.update_attributes!(moderation_state: ModerationStateMachine::DEFAULT_STATE)
      end
    end
  end

  def down
    # deliberately empty because the next migration in line will remove these fields
  end
end
