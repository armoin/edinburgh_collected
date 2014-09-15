class AddTimestampsToScrapbooks < ActiveRecord::Migration
  def change
    add_column :scrapbooks, :created_at, :datetime
    add_column :scrapbooks, :updated_at, :datetime
  end
end
