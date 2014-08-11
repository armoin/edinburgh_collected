class Area < ActiveRecord::Base
  validates :name, :city, :country, presence: true

  geocoded_by :location
  after_validation :geocode, if: :name_changed?

  def location
    "#{self.name}, #{self.city}, #{self.country}"
  end
end
