class AddAreaIdToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :area_id, :integer
  end
end
