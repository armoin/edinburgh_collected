require 'carrierwave/mount'

class Asset
  extend CarrierWave::Mount

  mount_uploader :source, ImageUploader

  attr_accessor :id, :title, :file_type, :url, :description,
                :width, :height, :resolution, :device, :length,
                :is_readable, :created_at, :updated_at

  def self.file_types
    ["image"]
  end

  def self.all
    AssetWrapper.fetchAll.map{|attrs| Asset.new(attrs)}
  end

  def self.create(attrs={})
    file = attrs.delete(:file)
    asset = Asset.new( AssetWrapper.create(attrs) )
    asset.source.store!(file) if file
    asset.url = asset.source.try(:url)
    AssetWrapper.update(asset)
  end

  def initialize(attrs={})
    attrs.each do |k,v|
      method = "#{k}=".to_sym
      send(method, v) if respond_to? method
    end
  end

  def thumb
    return '' unless url
    parts = url.split('/')
    file_name = parts.pop
    parts.push "thumb_#{file_name}"
    parts.join('/')
  end
end
