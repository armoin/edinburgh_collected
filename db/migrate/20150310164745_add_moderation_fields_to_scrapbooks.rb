class Scrapbook < ActiveRecord::Base; end

class AddModerationFieldsToScrapbooks < ActiveRecord::Migration
  def change
    add_column :scrapbooks, :moderation_state, :string
    add_column :scrapbooks, :moderation_reason, :string
    add_column :scrapbooks, :last_moderated_at, :datetime

    Scrapbook.all.each do |scrapbook|
      scrapbook.moderation_state  = ModerationStateMachine::DEFAULT_STATE
      scrapbook.last_moderated_at = Time.now
      scrapbook.save!
    end
  end
end
