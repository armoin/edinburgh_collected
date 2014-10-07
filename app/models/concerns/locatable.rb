module Locatable
  extend ActiveSupport::Concern

  included do
    geocoded_by :address

    after_validation :geocode, if: ->(obj){
      obj.location.present? && (obj.location_changed? || obj.area_id_changed?)
    }
    after_validation :blank_coords, unless: :location?
  end

  def address
    [location, area.try(:name)].reject{|s| s.blank?}.join(', ')
  end

  def latitude
    read_attribute(:latitude) || self.area.try(:latitude)
  end

  def longitude
    read_attribute(:longitude) || self.area.try(:longitude)
  end

  def has_coords?
    latitude.present? && longitude.present?
  end

  private

  def blank_coords
    self.latitude = nil
    self.longitude = nil
  end
end

