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

  def self.all
    AssetWrapper.fetchAll.map{|attrs| Asset.new(attrs)}
  end

  def self.find(id)
    attrs = AssetWrapper.fetch(id)
    Asset.new attrs
  end

  def self.create(attrs={})
    file = attrs.delete(:file)
    asset = Asset.new(attrs)
    if file
      asset.source.store!(file)
      asset.url = asset.source.try(:url)
    end
    AssetWrapper.create(asset)
  end

  def thumb
    return '' unless url
    parts = url.split('/')
    file_name = parts.pop
    parts.push "thumb_#{file_name}"
    parts.join('/')
  end
end
