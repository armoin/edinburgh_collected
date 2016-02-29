class CreateHomePages < ActiveRecord::Migration
  def change
    create_table :home_pages do |t|
      t.integer :featured_memory_id,            null: false
      t.integer :featured_scrapbook_id,         null: false
      t.string  :featured_scrapbook_memory_ids, null: false
      t.boolean :published,                     default: false

      t.timestamps
    end
  end
end
