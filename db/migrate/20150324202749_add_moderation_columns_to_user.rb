class AddModerationColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :moderation_state,  :string
    add_column :users, :moderated_by_id,   :integer
    add_column :users, :moderation_reason, :string
    add_column :users, :last_moderated_at, :datetime
  end
end
