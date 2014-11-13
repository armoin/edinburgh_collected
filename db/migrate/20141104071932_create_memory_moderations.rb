class CreateMemoryModerations < ActiveRecord::Migration
  def change
    create_table :memory_moderations do |t|
      t.integer :memory_id,     null: false
      t.string  :from_state, null: false
      t.string  :to_state,   null: false

      t.timestamps
    end
  end
end
