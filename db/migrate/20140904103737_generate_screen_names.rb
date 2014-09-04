class User < ActiveRecord::Base; end

class GenerateScreenNames < ActiveRecord::Migration
  def up
    User.where(screen_name: nil).each do |user|
      user.update_attribute :screen_name, "#{user.first_name.capitalize}#{user.last_name[0].upcase}"
    end
  end

  def down
    # we don't need to get rid of existing screen_names
  end
end
