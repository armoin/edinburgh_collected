require 'carrierwave/mount'

class Photo < Memory
  extend CarrierWave::Mount
  mount_uploader :source, ImageUploader

  validates :source, presence: true
  validates :year, presence: true

  attr_accessor :image_angle

  def label
    'picture'
  end

  def info_list
    [
      'We currently support files of type .gif, .jpg, .jpeg or .png',
      'We do not store image files at their original size. Please make sure that you store your own copy.',
      'Please be aware the uploading files from a mobile device may incur charges from your mobile service provider.'
    ]
  end

  def rotated?
    self.image_angle.present? && self.image_angle.to_f != 0
  end

  def update(params)
    super(params) && process_image
  end

  private

  def process_image
    return true unless rotated?

    self.updated_at = Time.now
    self.source.recreate_versions!
    self.save
  end
end
