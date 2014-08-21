class RenameImageToPhoto < ActiveRecord::Migration
  def up
    Memory.all.each do |m|
      m.update_attribute(:file_type, 'Photo') if m.file_type == 'Image'
    end
  end

  def down
    Memory.all.each do |m|
      m.update_attribute(:file_type, 'Image') if m.file_type == 'Photo'
    end
  end
end
