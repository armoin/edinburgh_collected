require 'carrierwave/mount'

class Asset
  include ActiveModel::Model
  extend CarrierWave::Mount

  mount_uploader :source, ImageUploader

  attr_accessor :id, :title, :file_type, :url, :description, :date,
                :width, :height, :resolution, :device, :length,
                :is_readable, :created_at, :updated_at

  def self.file_types
    ["image"]
  end

  validates_presence_of :date, :source, :title
  validates :file_type, inclusion: { in: Asset.file_types }

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
end
