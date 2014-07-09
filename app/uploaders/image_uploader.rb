# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{secure_token}"
  end

  def filename
    if original_filename
      extension = File.extname(original_filename)
      "original#{extension}"
    end
  end

  ## PROCESSING
  def fix_exif_rotation #this is my attempted solution
    manipulate! do |img|
      img.tap(&:auto_orient)
    end
  end

  process :fix_exif_rotation
  process :set_content_type
  version :thumb do
    process :resize_to_fit => [200, 200]
  end

  ## VALIDATION
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end

