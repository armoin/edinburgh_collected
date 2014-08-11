class ChangeAssetsToMemories < ActiveRecord::Migration
  def change
    rename_table :assets, :memories
  end
end
