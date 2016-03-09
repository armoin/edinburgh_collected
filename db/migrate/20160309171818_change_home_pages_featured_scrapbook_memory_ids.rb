class ChangeHomePagesFeaturedScrapbookMemoryIds < ActiveRecord::Migration
  def up
    change_column :home_pages, :featured_scrapbook_memory_ids, :string, null: true
  end

  def down
    change_column :home_pages, :featured_scrapbook_memory_ids, :string, null: false
  end
end
