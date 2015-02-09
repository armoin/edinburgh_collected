class AddFilterIndices < ActiveRecord::Migration
  def change
    add_index(:areas, :name)
    add_index(:categories, :name)
    add_index(:tags, :name)
  end
end
