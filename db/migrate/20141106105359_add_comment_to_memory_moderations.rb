class AddCommentToMemoryModerations < ActiveRecord::Migration
  def change
    add_column :memory_moderations, :comment, :text
  end
end
