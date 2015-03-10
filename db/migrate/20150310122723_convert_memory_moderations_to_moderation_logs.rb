class MemoryModeration < ActiveRecord::Base
  belongs_to :memory
end

class ModerationLog < ActiveRecord::Base
  belongs_to :moderatable, polymorphic: true
end

class Memory < ActiveRecord::Base
  has_many :memory_moderations
  has_many :moderation_logs, as: :moderatable
end

class ConvertMemoryModerationsToModerationLogs < ActiveRecord::Migration
  def up
    MemoryModeration.all.each do |mm|
      mm.memory.moderation_logs.create(
        from_state: mm.from_state,
        to_state:   mm.to_state,
        created_at: mm.created_at,
        updated_at: mm.updated_at,
        comment:    mm.comment
      )
    end
  end

  def down
    ModerationLog.where(moderatable_type: 'Memory').each do |ml|
      ml.moderatable.memory_moderations.create(
        from_state: ml.from_state,
        to_state:   ml.to_state,
        created_at: ml.created_at,
        updated_at: ml.updated_at,
        comment:    ml.comment
      )
    end
  end
end
