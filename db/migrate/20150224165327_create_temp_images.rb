class CreateTempImages < ActiveRecord::Migration
  def change
    create_table :temp_images do |t|
      t.string :file

      t.timestamps
    end
  end
end
