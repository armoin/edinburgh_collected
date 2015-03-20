class User < ActiveRecord::Base; end

class AddIsBlockedToUsers < ActiveRecord::Migration
  def up
    add_column :users, :is_blocked, :boolean, default: false

    User.all.each do |u|
      unless u.is_blocked?
        u.is_blocked = false
        u.save!
      end
    end
  end

  def down
    remove_column :users, :is_blocked
  end
end
