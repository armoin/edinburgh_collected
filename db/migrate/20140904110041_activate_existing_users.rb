class User < ActiveRecord::Base; end

class ActivateExistingUsers < ActiveRecord::Migration
  def up
    User.all.each do |u|
      u.update_attribute(:activation_state, 'active')
    end
  end

  def down
    User.all.each do |u|
      u.update_attribute(:activation_state, nil)
    end
  end
end
