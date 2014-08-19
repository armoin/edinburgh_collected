class RemoveMetaDataFromMemories < ActiveRecord::Migration
  def change
    remove_column :memories, :width
    remove_column :memories, :height
    remove_column :memories, :resolution
    remove_column :memories, :device
    remove_column :memories, :length
    remove_column :memories, :is_readable
  end
end
