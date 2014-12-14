class AddAcceptedTAndCToUsers < ActiveRecord::Migration
  def change
    add_column :users, :accepted_t_and_c, :boolean
  end
end
