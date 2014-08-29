class Photo < Memory
  mount_uploader :source, ImageUploader

  before_update :rotate_image, if: ->(obj){ obj.rotated? }

  def rotation=(degrees_string)
    @rotation = degrees_string.to_i
  end

  def rotated?
    self.rotation.present? && self.rotation != 0
  end

  private

  def rotate_image
    self.updated_at = Time.now
    self.source.recreate_versions!
  end
end

