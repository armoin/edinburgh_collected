class RenameFileTypeToTypeOnMemories < ActiveRecord::Migration
  def change
    rename_column :memories, :file_type, :type
  end
end
