class User < ActiveRecord::Base; include Moderatable; end

class RemoveIsBlockedFromUsers < ActiveRecord::Migration
  def change
    admin = User.find_by(is_admin: true)

    User.where(is_blocked: true).each do |user|
      user.block!(admin)
    end

    remove_column :users, :is_blocked, :boolean, default: false
  end
end
