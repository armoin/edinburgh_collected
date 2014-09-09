class CreateScrapbooks < ActiveRecord::Migration
  def change
    create_table :scrapbooks do |t|
      t.belongs_to  :user,        index: true
      t.string      :title,       null: false
      t.text        :description
    end
  end
end
