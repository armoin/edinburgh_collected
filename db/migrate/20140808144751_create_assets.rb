class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.integer  :user_id
      t.string   :title
      t.string   :file_type
      t.string   :source
      t.text     :description
      t.string   :year
      t.string   :month
      t.string   :day
      t.integer  :width
      t.integer  :height
      t.integer  :resolution
      t.string   :device
      t.float    :length
      t.boolean  :is_readable
      t.string   :attribution

      t.timestamps
    end
  end
end
