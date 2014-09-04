class AddIsGroupToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_group, :boolean, default: false
  end
end
