class CreateModerationLogs < ActiveRecord::Migration
  def change
    create_table :moderation_logs do |t|
      t.integer :moderatable_id,   null: false
      t.string  :moderatable_type, null: false
      t.string  :from_state,       null: false
      t.string  :to_state,         null: false
      t.text    :comment

      t.timestamps
    end
  end
end
