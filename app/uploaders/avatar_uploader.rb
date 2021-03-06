# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  WHITE_LIST = %w(JPG JPEG GIF PNG jpg jpeg gif png)

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{secure_token}.#{ext}" if original_filename.present?
  end

  def default_url(*args)
    "fallback/" + [version_name, "default_avatar.png"].compact.join('_')
  end

  ## PROCESSING
  def rotate
    manipulate! do |img|
      img.tap {|i| i.rotate angle }
    end
  end

  def resize
    manipulate! do |img|
      img.tap {|i| i.resize scale_percent }
    end
  end

  def crop
    manipulate! do |img|
      img.combine_options do |c|
        c.repage.+
        c.crop crop_geometry
        c.repage.+
      end
      img
    end
  end

  process :rotate, if: :is_rotated?
  process :resize, if: :is_scaled?
  process :crop,   if: :is_cropped?

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    if !WHITE_LIST.include?(file.extension) && WHITE_LIST.include?(filetype)
      [file.extension]
    else
      %w(JPG JPEG GIF PNG jpg jpeg gif png)
    end
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

  def filetype
    @filetype ||= FastImage.type(current_path).to_s
  end

  def ext
    @ext ||= WHITE_LIST.include?(file.extension) ? file.extension : filetype
  end

  private

  def is_rotated?(file)
    model.rotated?
  end

  def is_scaled?(file)
    model.scaled?
  end

  def is_cropped?(file)
    model.cropped?
  end

  def angle
    model.image_angle.to_s
  end

  def scale_percent
    "#{model.image_scale.to_f * 100}%"
  end

  def crop_geometry
    dimensions  = "#{model.image_w}x#{model.image_h}"
    coordinates = "#{coord(model.image_x)}+#{coord(model.image_y)}"
    "#{dimensions}+#{coordinates}"
  end

  def coord(value)
    return 0 if value.blank?
    value
  end
end
