class AddLocationToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :location, :string
    add_column :assets, :latitude, :float
    add_column :assets, :longitude, :float
  end
end
