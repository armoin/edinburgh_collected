class Memory < ActiveRecord::Base; end

class CapitalizeFileType < ActiveRecord::Migration
  def up
    Memory.all.each {|m| m.update_attribute(:file_type, m.file_type.capitalize)}
  end

  def down
    Memory.all.each {|m| m.update_attribute(:file_type, m.file_type.downcase)}
  end
end
