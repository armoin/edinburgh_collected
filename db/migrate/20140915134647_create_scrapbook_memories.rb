class CreateScrapbookMemories < ActiveRecord::Migration
  def change
    create_table :scrapbook_memories do |t|
      t.belongs_to :scrapbook, index: true
      t.belongs_to :memory,    index: true

      t.timestamps
    end
  end
end
