class Area < ActiveRecord::Base
  validates :name, :city, :country, presence: true

  geocoded_by :location
  after_validation :geocode, if: ->(obj){ obj.name_changed? && (!obj.latitude_changed? && !obj.longitude_changed?) }

  def location
    "#{self.name}, #{self.city}, #{self.country}"
  end
end
