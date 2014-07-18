require 'carrierwave/mount'

class Asset
  include ActiveModel::Model
  extend CarrierWave::Mount

  mount_uploader :source, ImageUploader

  attr_accessor :id, :title, :file_type, :url, :description,
                :year, :month, :day,
                :width, :height, :resolution, :device, :length,
                :is_readable, :created_at, :updated_at

  def self.file_types
    ["image"]
  end

  validates_presence_of :year, :source, :title
  validates :file_type, inclusion: { in: Asset.file_types }
  validate :file_is_of_correct_type

  def self.all
    AssetWrapper.fetchAll.map{|attrs| Asset.new(attrs)}
  end

  def self.find(id)
    attrs = AssetWrapper.fetch(id)
    Asset.new attrs
  end

  def save
    return false unless valid?
    source.store!
    self.url = source.try(:url)
    self.id = AssetWrapper.create(self)
  end

  def thumb
    return '' unless url
    parts = url.split('/')
    file_name = parts.pop
    parts.push "thumb_#{file_name}"
    parts.join('/')
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
