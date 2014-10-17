class AddOrderingToScrapbookMemories < ActiveRecord::Migration
  def up
    add_column :scrapbook_memories, :ordering, :integer

    ScrapbookMemory.all.group_by(&:scrapbook_id).values.each do |s|
      s.each.with_index do |sm, i|
        sm.ordering = i
        sm.save!
      end
    end
  end

  def down
    remove_column :scrapbook_memories, :ordering
  end
end
