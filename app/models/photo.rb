require 'carrierwave/mount'

class Photo < Memory
  extend CarrierWave::Mount
  mount_uploader :source, ImageUploader

  validates :source, presence: true

  attr_accessor :rotation

  def rotation=(degrees_string)
    @rotation = degrees_string.to_i
  end

  def rotated?
    self.rotation.present? && self.rotation != 0
  end

  def update(params)
    update_successful = super(params)
    if rotated? && update_successful
      update_successful = update_successful && rotate_image
    end
    update_successful
  end

  private

  def rotate_image
    self.updated_at = Time.now
    self.source.recreate_versions!
    self.save
  end
end
