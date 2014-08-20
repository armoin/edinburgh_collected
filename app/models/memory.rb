require 'carrierwave/mount'

class Memory < ActiveRecord::Base
  extend CarrierWave::Mount

  belongs_to :user
  belongs_to :area
  has_and_belongs_to_many :categories

  geocoded_by :address
  after_validation :geocode, if: :location_changed? or :area_id_changed?

  MAX_YEAR_RANGE = 120

  default_scope { order('created_at DESC') }

  def self.file_types
    ["Image"]
  end

  def self.furthest_year
    current_year - MAX_YEAR_RANGE
  end

  def self.current_year
    Time.now.year
  end

  validates_presence_of :title, :source, :user, :area, :year
  validates_presence_of :categories, message: 'must have at least one'
  validates :year,
            inclusion: { in: (furthest_year..current_year).map(&:to_s), message: 'must be within the last 120 years.' },
            if: :year_changed?
  validates :type, inclusion: { in: Memory.file_types }

  def date
    return year unless month.present?
    return month_string unless day.present?
    day_string
  end

  def address
    return "" if area.blank?
    return area.name if location.blank?
    "#{location}, #{area.name}"
  end

  def category_list
    categories.map(&:name).join(', ')
  end

  private

  def month_string
    Time.new(year, month).strftime('%B %Y')
  end

  def day_string
    day_ord = ActiveSupport::Inflector.ordinalize(day.to_i)
    Time.new(year, month).strftime("#{day_ord} %B %Y")
  end
end
