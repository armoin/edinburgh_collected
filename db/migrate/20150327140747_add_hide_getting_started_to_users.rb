class AddHideGettingStartedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hide_getting_started, :boolean
  end
end
