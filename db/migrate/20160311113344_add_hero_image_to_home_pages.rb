class AddHeroImageToHomePages < ActiveRecord::Migration
  def change
    add_column :home_pages, :hero_image, :string
  end
end
