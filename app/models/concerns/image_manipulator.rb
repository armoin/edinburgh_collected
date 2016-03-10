module ImageManipulator
  extend ActiveSupport::Concern

  included do
    attr_accessor :image_angle, :image_scale, :image_w, :image_h, :image_x, :image_y
  end

  def image_modified?
    rotated? || scaled? || cropped?
  end

  def rotated?
    present_and_non_zero?(self.image_angle)
  end

  def scaled?
    present_and_positive?(self.image_scale)
  end

  def cropped?
    present_and_positive?(self.image_w) && present_and_positive?(self.image_h)
  end

  def process_image
    return true unless image_modified?

    self.updated_at = Time.now
    uploader.recreate_versions! unless no_image? || new_image_uploaded?
    self.save
  end

  private

  def uploader_name
    self.class.uploaders.keys.first
  end

  def uploader
    self.send(uploader_name)
  end

  def no_image?
    uploader.blank?
  end

  def new_image_uploaded?
    self.previous_changes.has_key?(uploader_name)
  end

  def present_and_positive?(value)
    value.present? && value.to_f > 0
  end

  def present_and_non_zero?(value)
    value.present? && value.to_f != 0
  end
end

