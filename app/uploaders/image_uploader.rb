# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  def store_dir
    "uploads/memory/#{mounted_as}/#{model.id}"
  end

  ## PROCESSING
  def fix_exif_rotation
    manipulate! do |img|
      img.tap(&:auto_orient)
    end
  end

  def manual_rotation
    manipulate! do |img|
      img.rotate(model.rotation)
      img = yield(img) if block_given?
      img
    end
  end

  def is_rotated?(file)
    model.rotated?
  end

  process :fix_exif_rotation
  process :set_content_type
  process :manual_rotation, if: :is_rotated?
  version :thumb do
    process :resize_to_fit => [200, 200]
  end

  ## VALIDATION
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end

