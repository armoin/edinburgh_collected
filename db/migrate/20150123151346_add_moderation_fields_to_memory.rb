class AddModerationFieldsToMemory < ActiveRecord::Migration
  def change
    add_column :memories, :moderation_state, :string
    add_column :memories, :moderation_reason, :string
    add_column :memories, :last_moderated_at, :datetime
  end
end
