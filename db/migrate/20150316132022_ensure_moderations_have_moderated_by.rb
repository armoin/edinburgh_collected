class EnsureModerationsHaveModeratedBy < ActiveRecord::Migration
  def up
    moderator = User.find_by(is_admin: true)

    [Memory, Scrapbook].each do |moderatable_class|
      moderatable_class.all.each do |moderatable|
        moderatable.moderated_by = if moderatable.unmoderated?
          moderatable.user
        else
          moderator
        end
        moderatable.save!
      end
    end

    ModerationLog.all.each do |ml|
      ml.moderated_by = if ml.to_state == ModerationStateMachine::DEFAULT_STATE
        ml.moderatable.user
      else
        moderator
      end
      ml.save!
    end
  end

  def down
    # there is no down
  end
end
