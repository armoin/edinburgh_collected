class Photo < Memory
  mount_uploader :source, ImageUploader

  def rotation=(degrees_string)
    @rotation = degrees_string.to_i
  end

  def rotated?
    self.rotation.present? && self.rotation != 0
  end

  def update(params)
    super(params)
    rotate_image if rotated?
  end

  private

  def rotate_image
    self.updated_at = Time.now
    self.source.recreate_versions!
    self.save!
  end
end

