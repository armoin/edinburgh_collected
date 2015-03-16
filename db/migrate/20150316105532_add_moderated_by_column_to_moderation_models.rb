class AddModeratedByColumnToModerationModels < ActiveRecord::Migration
  def change
    add_column :memories,        :moderated_by_id, :integer, null: :false
    add_column :scrapbooks,      :moderated_by_id, :integer, null: :false

    add_column :moderation_logs, :moderated_by_id, :integer, null: :false
  end
end
