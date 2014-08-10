require 'carrierwave/mount'

class Asset < ActiveRecord::Base
  belongs_to :user
  belongs_to :area

  extend CarrierWave::Mount

  geocoded_by :address
  after_validation :geocode, if: :location_changed? or :area_id_changed?

  MAX_YEAR_RANGE = 120

  mount_uploader :source, ImageUploader

  default_scope { order('created_at DESC') }

  def self.file_types
    ["image"]
  end

  def self.furthest_year
    current_year - MAX_YEAR_RANGE
  end

  def self.current_year
    Time.now.year
  end

  validates_presence_of :title, :source, :user
  validates :year, presence: true, inclusion: { in: (furthest_year..current_year).map(&:to_s), message: 'must be within the last 120 years.' }
  validates :file_type, inclusion: { in: Asset.file_types }
  validates :area_id, inclusion: { in: [1] } #Area.all.map(&:id) }
  validate :file_is_of_correct_type

  def date
    if self.day.present? && self.month.present?
      day = ActiveSupport::Inflector.ordinalize(self.day.to_i)
      Time.new(self.year, self.month).strftime("#{day} %B %Y")
    elsif self.month.present?
      Time.new(self.year, self.month).strftime('%B %Y')
    else
      self.year
    end
  end

  def address
    return "" if area.blank?
    return area.name if location.blank?
    "#{location}, #{area.name}"
  end

  private

  def file_is_of_correct_type
    return false unless Asset.file_types.include?(self.file_type) # file_type validation will catch
    valid_exts_list = {
      'image' => %w(.jpg .jpeg .png .gif)
    }
    valid_exts = valid_exts_list[self.file_type]
    unless source.file && valid_exts.include?(File.extname(source.file.filename))
      errors.add(:source, "must be of type #{valid_exts.join(', ')}")
    end
  end
end
