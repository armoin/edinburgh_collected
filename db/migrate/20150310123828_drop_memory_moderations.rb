class DropMemoryModerations < ActiveRecord::Migration
  def change
    drop_table :memory_moderations do |t|
      t.integer :memory_id,     null: false
      t.string  :from_state,    null: false
      t.string  :to_state,      null: false
      t.text    :comment

      t.timestamps
    end
  end
end
