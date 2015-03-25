class User < ActiveRecord::Base; end

class EnsureUsersHaveCorrectModerationData < ActiveRecord::Migration
  def up
    moderator = User.find_by(is_admin: true)

    User.all.each do |user|
      user.moderation_state  = 'approved'
      user.moderated_by_id   = moderator.id
      user.last_moderated_at = Time.now
      user.save!
    end
  end

  def down
    User.all.each do |user|
      user.moderation_state  = nil
      user.moderated_by_id   = nil
      user.last_moderated_at = nil
      user.save!
    end
  end
end
