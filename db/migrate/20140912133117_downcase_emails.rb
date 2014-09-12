class DowncaseEmails < ActiveRecord::Migration
  def up
    User.all.each do |u|
      u.update_attribute(:email, u.email.try(:downcase))
    end
  end

  def down
    # nothing to do on down
  end
end
