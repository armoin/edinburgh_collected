require 'carrierwave/mount'

class Asset
  include ActiveModel::Model
  extend CarrierWave::Mount

  MAX_YEAR_RANGE = 120

  mount_uploader :source, ImageUploader

  attr_accessor :id, :title, :file_type, :url, :description,
                :user_id, :year, :month, :day,
                :width, :height, :resolution, :device, :length,
                :is_readable, :created_at, :updated_at

  def self.file_types
    ["image"]
  end

  def self.furthest_year
    current_year - MAX_YEAR_RANGE
  end

  def self.current_year
    Time.now.year
  end

  validates_presence_of :source, :title
  validates :year, presence: true, inclusion: { in: (furthest_year..current_year).map(&:to_s), message: 'must be within the last 120 years.' }
  validates :file_type, inclusion: { in: Asset.file_types }
  validate :file_is_of_correct_type

  def self.all
    AssetWrapper.fetchAll.map{|attrs| Asset.new(attrs)}
  end

  def self.user(token)
    AssetWrapper.fetchUser(token).map{|attrs| Asset.new(attrs)}
  end

  def self.find(id)
    attrs = AssetWrapper.fetch(id)
    Asset.new attrs
  end

  def save(auth_token)
    return false unless valid?
    source.store!
    self.url = source.try(:url)
    self.id = AssetWrapper.create(self, auth_token)
  end

  def thumb
    return '' unless url
    parts = url.split('/')
    file_name = parts.pop
    parts.push "thumb_#{file_name}"
    parts.join('/')
  end

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
