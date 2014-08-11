class AddCityAndCountryToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :city, :string
    add_column :areas, :country, :string
  end
end
